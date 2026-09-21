/* Este Banco da Dados refere-se ao trabalhos acadêmico da disciplina de Laboratório de Banco de Dados
 do Curso de Engenharia de Software da instituição de Ensino Universidade Católica de Brasília */
  
  create database FinanSys;
  use FinanSys;
  
  create table usuario (
	id int auto_increment primary key,
    email varchar(150) not null unique,
    senha varchar(255) not null,
    data_cadastro date not null,
    -- endereço
    logradouro varchar(150),
    numero varchar(20),
    complemento varchar(100),
    bairro varchar(100),
    cidade varchar(100),
    estado char(2),
    cep varchar(9)
) engine=InnoDB;

create table telefone(
	id int auto_increment primary key,
    usuario_id int not null,
    tipo enum('celular', 'residencial', 'comercial') not null,
    numero varchar(11) not null,
    constraint fk_telefone_usuario
		foreign key (usuario_id) references usuario(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table pessoa_fisica(
	id int primary key,
    cpf char(11) not null unique,
    nome_completo varchar(150) not null,
    data_nascimento date not null,
    constraint fk_pessoa_fisica_usuario
		foreign key (id) references usuario(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table pessoa_juridica(
	id int primary key,
    cnpj char(14) not null unique,
    razao_social varchar(150) not null,
    nome_fantasia varchar(150),
    data_inscricao date not null,
    constraint fk_pessoa_juridica_usuario
		foreign key (id) references usuario(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table perfil_configuracao(
	id int primary key,
    moeda_padrao char(3) not null default 'Brl',
    tema enum('claro', 'escuro') not null default 'claro',
    alerta_email boolean not null default true,
    limite_saldo_baixo decimal(14, 2) not null default 0,
    constraint fk_perfil_configuracao_usuario
		foreign key (id) references usuario(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table instituicao_financeira(
	id int auto_increment primary key,
    codigo_banco varchar(10) not null,
    nome varchar(150) not null,
    ispb char(8) not null unique
) engine=InnoDB;

create table conta(
	id int auto_increment primary key,
    usuario_id int not null,
    instituicao_id int not null,
    tipo enum('corrente', 'poupanca', 'investimento') not null,
    saldo decimal(14, 2) not null default 0,
    data_abertura date not null,
    situacao enum('ativa', 'inativa') not null default 'ativa',
    constraint fk_conta_usuario
		foreign key (usuario_id) references usuario(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table conta_corrente(
	id int primary key,
    limite_chaque_especial decimal(14, 2) not null default 0,
    taxa_manutencao decimal(10, 2) not null default 0,
    constraint fk_conta_corrente_conta
		foreign key (id) references conta(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table conta_poupanca(
	id int primary key,
    rendimento_mensal decimal(8, 2) not null default 0,
    dia_aniversario date not null,
    constraint fk_conta_poupanca_conta
		foreign key (id) references conta(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table conta_investimento(
	id int primary key,
    perfil_risco enum('conservador', 'moderado', 'arrojado') not null,
    taxa_custodia decimal(8, 2) not null default 0,
    constraint fk_conta_investimento_conta
		foreign key (id) references conta(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table cartao_credito(
	id int auto_increment primary key,
    conta_id int not null,
    instituicao_id int not null,
    apelido varchar(80),
    bandeira varchar(30),
    limite_total decimal(14, 2) not null,
    limite_disponivel decimal(14, 2) not null,
    dia_fechamento tinyint not null,
    dia_vencimento tinyint not null,
    constraint fk_cartao_credito_conta
		foreign key (conta_id) references conta(id)
        on delete cascade on update cascade,
	constraint fk_cartao_credito_instituicao_fincanceira
		foreign key (instituicao_id) references instituicao_financeira(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table fatura(
	id int auto_increment primary key,
    cartao_id int not null,
    mes_referencia char (7) not null,
    data_fechamento date not null,
    data_vencimento date not null,
    valor_total decimal(14, 2) not null default 0,
    situacao enum('aberta', 'fechada', 'paga', 'atrasada') not null default 'aberta',
    constraint fk_fatura_cartao
		foreign key (cartao_id) references cartao_credito(id)
        on delete cascade on update cascade,
	constraint uq_fatura_cartao_mes unique (cartao_id, mes_referencia)
) engine=InnoDB;

create table categoria(
	id int auto_increment primary key,
    categoria_pai_id int null,
    nome varchar(100) not null,
    descricao varchar(255),
    icone varchar(50),
    constraint fk_categoria_pai
		foreign key (categoria_pai_id) references categoria(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table tag(
	id int auto_increment primary key,
    nome varchar(50) not null unique
) engine=InnoDB;

create table orcamento(
	id int auto_increment primary key,
    usuario_id int not null,
    mes_ano char(7) not null,
    valor_teto decimal(14, 2) not null,
    constraint fk_orcamento_usuario
		foreign key (usuario_id) references usuario(id)
        on delete cascade on update cascade,
	constraint uq_orcamento_usuario_mes unique (usuario_id, mes_ano)
) engine=InnoDB;

create table item_orcamento(
	orcamento_id int not null,
    categoria_id int not null,
    valor_limite decimal(14, 2) not null,
    alerta_percentual decimal(5, 2) not null default 0,
    primary key(orcamento_id, categoria_id),
    constraint fk_item_orcamento_orcamento
		foreign key (orcamento_id) references orcamento(id)
        on delete cascade on update cascade,
	constraint fk_item_orcamento_categoria
		foreign key (categoria_id) references categoria(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table transacao(
	id int auto_increment primary key,
    conta_id int not null,
    categoria_id int not null,
    cartao_id int not null,
    valor decimal(14, 2) not null,
    data_hora datetime not null,
    descricao varchar(255),
    situacao enum('pendente', 'concluida', 'cancelada') not null default 'concluida',
    forma_pagamento varchar(40),
    constraint fk_transacao_conta
		foreign key (conta_id) references conta(id)
        on delete cascade on update cascade,
	constraint fk_transacao_categoria
		foreign key (categoria_id) references categoria(id)
        on delete cascade on update cascade,
	constraint fk_transacao_cartao
		foreign key (cartao_id) references cartao_credito(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table receita(
	id int primary key,
    fonte_recurso varchar(150),
    recorrente boolean not null default false,
    constraint fk_receita_transacao
		foreign key (id) references transacao(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table despesa(
	id int primary key,
    favorecido varchar(150) not null,
    dedutivel_imposto boolean not null default false,
    constraint fk_despesa_transacao
		foreign key (id) references transacao(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table transferencia(
	transacao_id int primary key,
    conta_origem_id int not null,
    conta_destino_id int not null,
    taxa_cambio decimal(14, 2) not null default 0,
    valor_convertido decimal(14, 2) not null,
    valor_tarifa decimal(14, 2) not null default 0,
    constraint fk_transferencia_transacao
		foreign key (transacao_id) references transacao(id)
        on delete cascade on update cascade,
    constraint fk_transferencia_origem
		foreign key (conta_origem_id) references conta(id)
        on delete restrict on update restrict,
    constraint fk_transferencia_destino
		foreign key (conta_destino_id) references conta(id)
        on delete restrict on update restrict,
    constraint ck_transferencia_contas_diferentes
		check (conta_origem_id <> conta_destino_id)
) engine=InnoDB;

create table parcela(
	transacao_id int not null,
    numero_parcela smallint not null,
    fatura_id int not null,
    valor_individual decimal(14, 2) not null,
    data_vencimento date not null,
    data_pagamento date null,
    primary key (transacao_id, numero_parcela),
    constraint fk_parcela_transacao
		foreign key (transacao_id) references transacao(id)
        on delete cascade on update cascade,
	constraint fk_parcela_fatura
		foreign key (fatura_id) references fatura(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table transacao_tag(
	transacao_id int not null,
    tag_id int not null,
    primary key (transacao_id, tag_id),
    constraint fk_transacao_tag_transacao
		foreign key (transacao_id) references transacao(id)
        on delete cascade on update cascade,
	constraint fk_transacao_tag_tag
		foreign key (tag_id) references tag(id)
        on delete cascade on update cascade
) engine=InnoDB;

create table ativo(
	id int auto_increment primary key,
    nome varchar(30) not null,
    classe enum('acao', 'fundo', 'renda_fixa', 'criptomoeda') not null
) engine=InnoDB;

create table operacao_investimento(
	id int auto_increment primary key,
    ativo_id int not null,
    conta_investimento_id int not null,
    tipo enum('compra', 'venda') not null,
    quantidade decimal(14, 6) not null,
    preco_unitario decimal(14, 2) not null,
    taxas decimal(14, 2) not null default 0,
    data_pagamento date not null,
    constraint fk_operacao_investimento_ativo
		foreign key (ativo_id) references ativo(id)
        on delete cascade on update cascade,
	constraint fk_operacao_investimento_conta_investimento
        foreign key (conta_investimento_id) references conta_investimento(id)
        on delete cascade on update cascade
) engine=InnoDB;