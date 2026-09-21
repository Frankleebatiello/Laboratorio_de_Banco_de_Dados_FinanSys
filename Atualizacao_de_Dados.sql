USE FinanSys;

-- -----------------------------------------------------------------
-- 1. Marcar uma fatura como paga
-- -----------------------------------------------------------------
UPDATE fatura
SET situacao = 'paga'
WHERE id = 1;

-- -----------------------------------------------------------------
-- 2. Registrar o pagamento de uma parcela específica
-- -----------------------------------------------------------------
UPDATE parcela
SET data_pagamento = CURDATE()
WHERE transacao_id = 2
  AND numero_parcela = 2;

-- -----------------------------------------------------------------
-- 3. Debitar o valor de uma compra no limite disponível do cartão
-- -----------------------------------------------------------------
UPDATE cartao_credito
SET limite_disponivel = limite_disponivel - 45.90
WHERE id = 1;

-- -----------------------------------------------------------------
-- 4. Atualizar o saldo da conta após uma transação (receita)
-- -----------------------------------------------------------------
UPDATE conta
SET saldo = saldo + 4200.00
WHERE id = 3;

-- -----------------------------------------------------------------
-- 5. Atualizar o saldo das duas contas envolvidas em uma transferência
-- -----------------------------------------------------------------
UPDATE conta
SET saldo = saldo - 500.00
WHERE id = 1;

UPDATE conta
SET saldo = saldo + 500.00
WHERE id = 2;

-- -----------------------------------------------------------------
-- 6. Inativar uma conta (encerramento)
-- -----------------------------------------------------------------
UPDATE conta
SET situacao = 'inativa'
WHERE id = 2;

-- -----------------------------------------------------------------
-- 7. Alterar o tema da interface de um usuário
-- -----------------------------------------------------------------
UPDATE perfil_configuracao
SET tema = 'claro'
WHERE id = 1;

-- -----------------------------------------------------------------
-- 8. Reajustar o teto de um orçamento mensal
-- -----------------------------------------------------------------
UPDATE orcamento
SET valor_teto = valor_teto * 1.10
WHERE id = 1;

-- -----------------------------------------------------------------
-- 9. Ajustar o percentual de alerta de um item de orçamento
-- -----------------------------------------------------------------
UPDATE item_orcamento
SET alerta_percentual = 90.00
WHERE orcamento_id = 1
  AND categoria_id = 1;

-- -----------------------------------------------------------------
-- 10. Cancelar uma transação (mudar situação, mantendo o histórico)
-- -----------------------------------------------------------------
UPDATE transacao
SET situacao = 'cancelada'
WHERE id = 3;

-- -----------------------------------------------------------------
-- 11. Corrigir o nome fantasia de uma pessoa jurídica
-- -----------------------------------------------------------------
UPDATE pessoa_juridica
SET nome_fantasia = 'Nova Contábil Assessoria'
WHERE id = 3;

-- -----------------------------------------------------------------
-- 12. Atualizar limite total do cartão (aumento de limite concedido)
-- -----------------------------------------------------------------
UPDATE cartao_credito
SET limite_total = limite_total + 1000.00,
    limite_disponivel = limite_disponivel + 1000.00
WHERE id = 2;
