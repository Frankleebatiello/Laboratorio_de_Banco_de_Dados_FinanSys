USE FinanSys;
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO usuario (id, email, senha, data_cadastro, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
(1, 'ana.souza@example.com',        'hash_ana_123',     '2024-02-10', 'Rua das Flores',        '120', 'Apto 45',  'Centro',        'Brasília',      'DF', '70000-100'),
(2, 'carlos.lima@example.com',      'hash_carlos_123',  '2024-03-22', 'Av. Comercial',         '980', NULL,       'Asa Sul',       'Brasília',      'DF', '70200-200'),
(3, 'contato@novacontabil.com.br',  'hash_pj_123',      '2024-05-05', 'SIA Trecho 3',          '1500', 'Bloco B', 'SIA',           'Brasília',      'DF', '71200-030');

INSERT INTO telefone (id, usuario_id, tipo, numero) VALUES
(1, 1, 'celular',     '61987654321'),
(2, 1, 'residencial', '6132211122'),
(3, 2, 'celular',     '61999887766'),
(4, 3, 'comercial',   '6133445566');

INSERT INTO pessoa_fisica (id, cpf, nome_completo, data_nascimento) VALUES
(1, '11122233344', 'Ana Souza',   '1992-04-15'),
(2, '22233344455', 'Carlos Lima', '1988-11-02');

INSERT INTO pessoa_juridica (id, cnpj, razao_social, nome_fantasia, data_inscricao) VALUES
(3, '12345678000199', 'Nova Contabilidade LTDA', 'Nova Contábil', '2024-05-05');

INSERT INTO perfil_configuracao (id, moeda_padrao, tema, alerta_email, limite_saldo_baixo) VALUES
(1, 'BRL', 'escuro', TRUE,  200.00),
(2, 'BRL', 'claro',  TRUE,  500.00),
(3, 'BRL', 'claro',  FALSE, 1000.00);

INSERT INTO instituicao_financeira (id, codigo_banco, nome, ispb) VALUES
(1, '001', 'Banco do Brasil', '00000000'),
(2, '260', 'Nu Pagamentos',   '18236120'),
(3, '102', 'XP Investimentos','02332886');

INSERT INTO conta (id, usuario_id, instituicao_id, tipo, saldo, data_abertura, situacao) VALUES
(1, 1, 1, 'corrente',     3250.40, '2024-02-10', 'ativa'),
(2, 1, 2, 'poupanca',     1500.00, '2024-02-15', 'ativa'),
(3, 2, 1, 'corrente',     4890.00, '2024-03-22', 'ativa'),
(4, 2, 3, 'investimento', 12800.00,'2024-04-01', 'ativa'),
(5, 3, 1, 'corrente',     15200.00,'2024-05-05', 'ativa');

INSERT INTO conta_corrente (id, limite_chaque_especial, taxa_manutencao) VALUES
(1, 1000.00, 29.90),
(3, 500.00,  19.90),
(5, 5000.00, 49.90);

INSERT INTO conta_poupanca (id, rendimento_mensal, dia_aniversario) VALUES
(2, 0.55, '2024-02-15');

INSERT INTO conta_investimento (id, perfil_risco, taxa_custodia) VALUES
(4, 'moderado', 0.20);

INSERT INTO cartao_credito (id, conta_id, instituicao_id, apelido, bandeira, limite_total, limite_disponivel, dia_fechamento, dia_vencimento) VALUES
(1, 1, 1, 'Cartão Ana BB',      'Visa',       5000.00, 4200.00, 25, 5),
(2, 3, 1, 'Cartão Carlos BB',   'Mastercard', 6000.00, 5500.00, 20, 1),
(3, 5, 1, 'Cartão Empresarial', 'Mastercard', 20000.00,18500.00,28, 10);

INSERT INTO fatura (id, cartao_id, mes_referencia, data_fechamento, data_vencimento, valor_total, situacao) VALUES
(1, 1, '2025-08', '2025-08-25', '2025-09-05', 175.00, 'paga'),
(2, 1, '2025-09', '2025-09-25', '2025-10-05', 220.90, 'aberta'),
(3, 2, '2025-09', '2025-09-20', '2025-10-01', 200.00, 'aberta'),
(4, 3, '2025-09', '2025-09-28', '2025-10-10', 1200.00,'aberta');

INSERT INTO categoria (id, categoria_pai_id, nome, descricao, icone) VALUES
(1,  NULL, 'Alimentação',    'Gastos com comida',              'utensils'),
(2,  1,    'Supermercado',   'Compras de mercado',              'cart'),
(3,  1,    'Delivery',       'Pedidos de comida por aplicativo','moto'),
(4,  NULL, 'Transporte',     'Locomoção em geral',              'car'),
(5,  4,    'Combustível',    'Abastecimento de veículo',        'fuel'),
(6,  NULL, 'Salário',        'Recebimentos de renda fixa',      'wallet'),
(7,  NULL, 'Saúde',          'Gastos médicos e farmácia',       'health'),
(8,  NULL, 'Lazer',          'Entretenimento em geral',         'game'),
(9,  NULL, 'Transferências', 'Movimentações entre contas',      'exchange'),
(10, NULL, 'Serviços',       'Serviços contratados (PJ)',       'briefcase');

INSERT INTO tag (id, nome) VALUES
(1, '#viagem'),
(2, '#trabalho'),
(3, '#reembolsavel'),
(4, '#urgente');

INSERT INTO orcamento (id, usuario_id, mes_ano, valor_teto) VALUES
(1, 1, '2025-09', 3000.00),
(2, 2, '2025-09', 2000.00);

INSERT INTO item_orcamento (orcamento_id, categoria_id, valor_limite, alerta_percentual) VALUES
(1, 1, 800.00, 80.00),
(1, 4, 400.00, 75.00),
(2, 1, 600.00, 80.00);

INSERT INTO transacao (id, conta_id, categoria_id, cartao_id, valor, data_hora, descricao, situacao, forma_pagamento) VALUES
(1, 1, 6, 1, 5000.00, '2025-09-05 08:00:00', 'Salário mensal - Empregador XPTO',   'concluida', 'deposito'),
(2, 1, 2, 1,  350.00, '2025-09-10 18:32:00', 'Compras no supermercado (2x)',      'concluida', 'credito'),
(3, 1, 3, 1,   45.90, '2025-09-12 20:15:00', 'Pedido de comida via app',          'concluida', 'credito'),
(4, 3, 5, 2,  200.00, '2025-09-08 11:00:00', 'Abastecimento posto Shell',         'concluida', 'credito'),
(5, 3, 6, 2, 4200.00, '2025-09-05 08:00:00', 'Salário mensal - Empresa ABC',      'concluida', 'deposito'),
(6, 1, 9, 1,  500.00, '2025-09-15 09:20:00', 'Transferência para poupança',       'concluida', 'transferencia'),
(7, 5, 10,3, 1200.00, '2025-09-18 14:00:00', 'Pagamento de contabilidade externa','concluida', 'credito');

INSERT INTO receita (id, fonte_recurso, recorrente) VALUES
(1, 'Empregador XPTO', TRUE),
(5, 'Empresa ABC',     TRUE);

INSERT INTO despesa (id, favorecido, dedutivel_imposto) VALUES
(2, 'Supermercado Pão de Açúcar', FALSE),
(3, 'iFood',                      FALSE),
(4, 'Posto Shell',                FALSE),
(7, 'Nova Contábil - Serviços',   TRUE);

INSERT INTO transferencia (transacao_id, conta_origem_id, conta_destino_id, taxa_cambio, valor_convertido, valor_tarifa) VALUES
(6, 1, 2, 1.00, 500.00, 0.00);

INSERT INTO parcela (transacao_id, numero_parcela, fatura_id, valor_individual, data_vencimento, data_pagamento) VALUES
(2, 1, 1, 175.00, '2025-09-05', '2025-09-03'),
(2, 2, 2, 175.00, '2025-10-05', NULL);

INSERT INTO transacao_tag (transacao_id, tag_id) VALUES
(2, 3),  -- compra do mercado marcada como reembolsável
(3, 2),  -- delivery marcado como trabalho
(6, 4);  -- transferência marcada como urgente

INSERT INTO ativo (id, nome, classe) VALUES
(1, 'PETR4',            'acao'),
(2, 'Tesouro Selic 2029','renda_fixa'),
(3, 'BTC',              'criptomoeda');

INSERT INTO operacao_investimento (id, ativo_id, conta_investimento_id, tipo, quantidade, preco_unitario, taxas, data_pagamento) VALUES
(1, 1, 4, 'compra', 100.000000,   32.50,   5.00, '2025-07-10'),
(2, 2, 4, 'compra', 1000.000000, 1.0021,  0.00, '2025-07-15'),
(3, 3, 4, 'compra', 0.015000,    350000.00,10.00,'2025-08-01'),
(4, 1, 4, 'venda',  30.000000,   35.10,   3.00, '2025-09-10');
