CREATE TABLE tb_entidade
(
    id_entidade integer NOT NULL DEFAULT nextval('tb_id_entidade_id_entidade_seq'::regclass),
    nome_entidade character varying NOT NULL,
    data_credenciamento date NOT NULL,
    numero_processo character varying NOT NULL,
    CONSTRAINT tb_id_entidade_pkey PRIMARY KEY (id_entidade),
    CONSTRAINT tb_id_entidade_nome_entidade_key UNIQUE (nome_entidade)

);

CREATE TABLE tb_arquivo_entidade
(
    id_arquivo integer NOT NULL DEFAULT nextval('tb_arquivo_entidade_id_arquivo_seq'::regclass),
    nome_arquivo character varying,
    id_entidade_origem integer,
    ts_inicio_periodo date,
    ts_fim_periodo date,
    data_envio date,
    CONSTRAINT tb_arquivo_entidade_pkey PRIMARY KEY (id_arquivo)
    CONSTRAINT fk_id_entidade FOREIGN KEY (id_entidade_origem)
        REFERENCES tb_id_entidade (id_entidade) MATCH SIMPLE
);

CREATE TABLE tb_controle_responsaveis
(
    id_controle_responsaveis integer NOT NULL DEFAULT nextval('tb_controle_responsaveis_id_controle_responsaveis_seq'::regclass),
    nome_responsavel character varying NOT NULL,
    cargo_funcao character varying,
    email_responsavel character varying NOT NULL,
    telefone_responsavel character varying,
    id_arquivo integer NOT NULL,
    id_entidade integer NOT NULL,
    CONSTRAINT tb_controle_responsaveis_pkey PRIMARY KEY (id_controle_responsaveis)
    CONSTRAINT fk_id_entidade FOREIGN KEY (id_entidade_origem)
        REFERENCES tb_id_entidade (id_entidade) MATCH SIMPLE
    CONSTRAINT fk_id_arquivo FOREIGN KEY (id_arquivo)
        REFERENCES tb_arquivo_entidade (id_arquivo) MATCH SIMPLE    
);

CREATE TABLE tb_erros_enviados
(
    id_erro_enviado integer NOT NULL DEFAULT nextval('tb_erros_enviados_id_erro_enviado_seq'::regclass),
    ts_erro timestamp without time zone,
    tcn_transentidade_nivel_2 character varying NOT NULL,
    tcr_transentidade_nivel_2 character varying NOT NULL,
    tot_transentidade_nivel_2 character varying NOT NULL,
    internal_error_code character varying NOT NULL,
    internal_error_message character varying,
    response_error_code character varying,
    response_error_message character varying,
    id_entidade_absoluto integer NOT NULL,
    id_entidade_destino integer NOT NULL,
    id_arquivo integer NOT NULL,
    CONSTRAINT tb_erros_enviados_pkey PRIMARY KEY (id_erro_enviado)
    CONSTRAINT tb_controle_responsaveis_pkey PRIMARY KEY (id_controle_responsaveis)
    CONSTRAINT fk_id_entidade_absoluto FOREIGN KEY (id_entidade_absoluto)
        REFERENCES tb_id_entidade (id_entidade) MATCH SIMPLE
    CONSTRAINT fk_id_entidade_destino FOREIGN KEY (id_entidade_destino)
    REFERENCES tb_id_entidade (id_entidade) MATCH SIMPLE
    CONSTRAINT fk_id_arquivo FOREIGN KEY (id_arquivo)
        REFERENCES tb_arquivo_entidade (id_arquivo) MATCH SIMPLE 
);

CREATE TABLE tb_erros_enviados
(
    id_erro_enviado integer NOT NULL DEFAULT nextval('tb_erros_enviados_id_erro_enviado_seq'::regclass),
    ts_erro timestamp without time zone,
    tcn_transentidade_nivel_2 character varying NOT NULL,
    tcr_transentidade_nivel_2 character varying NOT NULL,
    tot_transentidade_nivel_2 character varying NOT NULL,
    internal_error_code character varying NOT NULL,
    internal_error_message character varying,
    response_error_code character varying,
    response_error_message character varying,
    id_entidade_absoluto integer NOT NULL,
    id_entidade_destino integer NOT NULL,
    id_arquivo integer NOT NULL,
    CONSTRAINT tb_erros_enviados_pkey PRIMARY KEY (id_erro_enviado)
);

CREATE TABLE tb_erros_recebidos
(
    id_erro_recebido integer NOT NULL DEFAULT nextval('tb_erros_recebidos_id_erro_recebido_seq'::regclass),
    ts_erro timestamp without time zone,
    tcn_transentidade_nivel_2 character varying NOT NULL,
    tcr_transentidade_nivel_2 character varying NOT NULL,
    tot_transentidade_nivel_2 character varying NOT NULL,
    internal_error_code character varying NOT NULL,
    internal_error_message character varying,
    response_error_code character varying,
    response_error_message character varying,
    id_entidade_absoluto integer NOT NULL,
    id_entidade_origem integer NOT NULL,
    id_arquivo integer NOT NULL,
    CONSTRAINT tb_erros_recebidos_pkey PRIMARY KEY (id_erro_recebido)
);

CREATE TABLE tb_solicitentidade_nivel_2oes_enviadas_entidade
(
    id_enviadas_entidade integer NOT NULL DEFAULT nextval('tb_solicitentidade_nivel_2oes_enviadas_entidade_id_enviadas_entidade_seq'::regclass),
    numero_enviadas integer NOT NULL,
    numero_processadas integer NOT NULL,
    id_entidade_absoluto integer NOT NULL,
    id_entidade_relativo integer NOT NULL,
    id_arquivo integer NOT NULL,
    CONSTRAINT solicitentidade_nivel_2oes_enviadas_entidade_pkey PRIMARY KEY (id_enviadas_entidade)
);

CREATE TABLE tb_solicitentidade_nivel_2oes_recebidas_entidade_nivel_2
(
    id_recebidas_entidade_nivel_2 integer NOT NULL DEFAULT nextval('tb_solicitentidade_nivel_2oes_recebidas_entidade_nivel_2_id_recebidas_entidade_nivel_2_seq'::regclass),
    numero_recebidas integer NOT NULL,
    numero_processadas integer NOT NULL,
    id_entidade_absoluto integer NOT NULL,
    id_arquivo integer NOT NULL,
    nome_entidade_nivel_2 character varying NOT NULL,
    CONSTRAINT solicitentidade_nivel_2oes_recebidas_entidade_nivel_2_pkey PRIMARY KEY (id_recebidas_entidade_nivel_2)
);

CREATE TABLE tb_solicitentidade_nivel_2oes_recebidas_entidade
(
    id_recebidas_entidade integer NOT NULL DEFAULT nextval('tb_solicitentidade_nivel_2oes_recebidas_entidade_id_recebidas_entidade_seq'::regclass),
    numero_recebidas integer,
    numero_processadas integer,
    id_entidade_absoluto integer NOT NULL,
    id_entidade_relativo integer NOT NULL,
    id_arquivo integer NOT NULL,
    CONSTRAINT tb_solicitentidade_nivel_2oes_recebidas_entidade_pkey PRIMARY KEY (id_recebidas_entidade)
);

CREATE TABLE tb_transentidade_nivel_2_processadas_entidade_nivel_2
(
    id_transentidade_nivel_2_entidade_nivel_2 integer NOT NULL DEFAULT nextval('tb_transentidade_nivel_2_processadas_entidade_nivel_2_id_transentidade_nivel_2_entidade_nivel_2_seq'::regclass),
    referencia_transentidade_nivel_2ao integer NOT NULL,
    entidade_nivel_2_origem character varying NOT NULL,
    idn_transentidade_nivel_2 character varying NOT NULL,
    tcn_transentidade_nivel_2 character varying NOT NULL,
    tot_transentidade_nivel_2 character varying NOT NULL,
    ts_inicio_transentidade_nivel_2ao timestamp without time zone,
    ts_fim_transentidade_nivel_2ao timestamp without time zone,
    ts_total_transentidade_nivel_2ao interval,
    transentidade_nivel_2_mensagem character varying NOT NULL,
    id_entidade_absoluto integer NOT NULL,
    id_arquivo integer NOT NULL,
    CONSTRAINT transentidade_nivel_2_processadas_entidade_nivel_2_pkey PRIMARY KEY (id_transentidade_nivel_2_entidade_nivel_2)
);

CREATE TABLE tb_transentidade_nivel_2_processadas_entidade
(
    id_transentidade_nivel_2_entidade integer NOT NULL DEFAULT nextval('tb_transentidade_nivel_2_processadas_entidade_id_transentidade_nivel_2_entidade_seq'::regclass),
    referencia_transentidade_nivel_2ao integer NOT NULL,
    idn_transentidade_nivel_2 character varying NOT NULL,
    tcn_transentidade_nivel_2 character varying NOT NULL,
    tot_transentidade_nivel_2 character varying NOT NULL,
    ts_inicio_transentidade_nivel_2ao timestamp without time zone,
    ts_fim_transentidade_nivel_2ao timestamp without time zone,
    ts_total_transentidade_nivel_2ao interval,
    transentidade_nivel_2_mensagem character varying NOT NULL,
    id_entidade_origem integer NOT NULL,
    id_entidade_destino integer NOT NULL,
    id_arquivo integer NOT NULL,
    CONSTRAINT transentidade_nivel_2_processadas_entidade_pkey PRIMARY KEY (id_transentidade_nivel_2_entidade)
);

