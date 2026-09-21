USE FinanSys;

-- -----------------------------------------------------------------
-- 1. Extrato de uma conta específica (transações + categoria)
-- -----------------------------------------------------------------
SELECT
    t.id AS transacao_id,
    t.data_hora,
    t.descricao,
    t.valor,
    t.situacao,
    c.nome AS categoria
FROM transacao t
JOIN categoria c ON c.id = t.categoria_id
WHERE t.conta_id = 1
ORDER BY t.data_hora;

-- -----------------------------------------------------------------
-- 2. Saldo consolidado de todas as contas de um usuário
-- -----------------------------------------------------------------
SELECT
    u.id AS usuario_id,
    u.email,
    SUM(c.saldo) AS patrimonio_em_contas
FROM usuario u
JOIN conta c ON c.usuario_id = u.id
WHERE u.id = 1
GROUP BY u.id, u.email;

-- -----------------------------------------------------------------
-- 3. Total gasto por categoria em um determinado mês (só despesas)
-- -----------------------------------------------------------------
SELECT
    cat.nome AS categoria,
    SUM(t.valor) AS total_gasto,
    COUNT(*) AS qtd_transacoes
FROM transacao t
JOIN despesa d   ON d.id = t.id
JOIN categoria cat ON cat.id = t.categoria_id
WHERE t.conta_id = 1
  AND DATE_FORMAT(t.data_hora, '%Y-%m') = '2025-09'
GROUP BY cat.nome
ORDER BY total_gasto DESC;

-- -----------------------------------------------------------------
-- 4. Percentual de consumo do orçamento por categoria
-- -----------------------------------------------------------------
SELECT
    o.mes_ano,
    cat.nome AS categoria,
    io.valor_limite,
    COALESCE(gasto.total, 0) AS gasto_atual,
    ROUND(COALESCE(gasto.total, 0) / io.valor_limite * 100, 2) AS percentual_consumido,
    io.alerta_percentual
FROM item_orcamento io
JOIN orcamento o   ON o.id = io.orcamento_id
JOIN categoria cat ON cat.id = io.categoria_id
LEFT JOIN (
    SELECT t.categoria_id, t.conta_id, SUM(t.valor) AS total
    FROM transacao t
    JOIN despesa d ON d.id = t.id
    WHERE DATE_FORMAT(t.data_hora, '%Y-%m') = '2025-09'
    GROUP BY t.categoria_id, t.conta_id
) gasto ON gasto.categoria_id = io.categoria_id
WHERE o.usuario_id = 1
  AND o.mes_ano = '2025-09';

-- -----------------------------------------------------------------
-- 5. Faturas em aberto ou atrasadas, com o cartão e a conta pagadora
-- -----------------------------------------------------------------
SELECT
    f.id AS fatura_id,
    cc.apelido AS cartao,
    ct.id AS conta_pagadora,
    f.mes_referencia,
    f.valor_total,
    f.data_vencimento,
    f.situacao
FROM fatura f
JOIN cartao_credito cc ON cc.id = f.cartao_id
JOIN conta ct ON ct.id = cc.conta_id
WHERE f.situacao IN ('aberta', 'atrasada')
ORDER BY f.data_vencimento;

-- -----------------------------------------------------------------
-- 6. Parcelas ainda não pagas, com vencimento próximo
-- -----------------------------------------------------------------
SELECT
    p.transacao_id,
    p.numero_parcela,
    t.descricao,
    p.valor_individual,
    p.data_vencimento
FROM parcela p
JOIN transacao t ON t.id = p.transacao_id
WHERE p.data_pagamento IS NULL
ORDER BY p.data_vencimento;

-- -----------------------------------------------------------------
-- 7. Categorias com suas subcategorias (autorrelacionamento)
-- -----------------------------------------------------------------
SELECT
    pai.nome AS categoria_pai,
    filha.nome AS subcategoria
FROM categoria filha
LEFT JOIN categoria pai ON pai.id = filha.categoria_pai_id
ORDER BY COALESCE(pai.nome, filha.nome), filha.nome;

-- -----------------------------------------------------------------
-- 8. Transações com suas tags (relacionamento N:M via transacao_tag)
-- -----------------------------------------------------------------
SELECT
    t.id AS transacao_id,
    t.descricao,
    GROUP_CONCAT(tg.nome SEPARATOR ', ') AS tags
FROM transacao t
JOIN transacao_tag tt ON tt.transacao_id = t.id
JOIN tag tg ON tg.id = tt.tag_id
GROUP BY t.id, t.descricao;

-- -----------------------------------------------------------------
-- 9. Transferências realizadas, com conta de origem e destino
-- -----------------------------------------------------------------
SELECT
    tr.transacao_id,
    t.data_hora,
    co.id AS conta_origem,
    cd.id AS conta_destino,
    tr.valor_convertido,
    tr.valor_tarifa
FROM transferencia tr
JOIN transacao t ON t.id = tr.transacao_id
JOIN conta co ON co.id = tr.conta_origem_id
JOIN conta cd ON cd.id = tr.conta_destino_id
ORDER BY t.data_hora;

-- -----------------------------------------------------------------
-- 10. Preço médio e quantidade em carteira por ativo (rentabilidade simplificada)
-- -----------------------------------------------------------------
SELECT
    a.nome AS ativo,
    SUM(CASE WHEN oi.tipo = 'compra' THEN oi.quantidade ELSE -oi.quantidade END) AS qtd_em_carteira,
    ROUND(
        SUM(CASE WHEN oi.tipo = 'compra' THEN oi.quantidade * oi.preco_unitario ELSE 0 END)
        / NULLIF(SUM(CASE WHEN oi.tipo = 'compra' THEN oi.quantidade ELSE 0 END), 0)
    , 4) AS preco_medio_compra
FROM operacao_investimento oi
JOIN ativo a ON a.id = oi.ativo_id
GROUP BY a.nome;

-- -----------------------------------------------------------------
-- 11. Usuários com sua especialização (PF ou PJ) numa única consulta
-- -----------------------------------------------------------------
SELECT
    u.id,
    u.email,
    COALESCE(pf.nome_completo, pj.razao_social) AS nome_ou_razao_social,
    CASE WHEN pf.id IS NOT NULL THEN 'PF' ELSE 'PJ' END AS tipo_usuario
FROM usuario u
LEFT JOIN pessoa_fisica    pf ON pf.id = u.id
LEFT JOIN pessoa_juridica  pj ON pj.id = u.id;
