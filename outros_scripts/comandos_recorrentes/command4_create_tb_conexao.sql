CREATE TABLE public.tb_conexao (
    id_banco smallint NOT NULL,
    c_host character varying COLLATE pg_catalog."default" NOT NULL,
    c_port character varying COLLATE pg_catalog."default" NOT NULL,
    c_dbname character varying COLLATE pg_catalog."default" NOT NULL,
    c_user character varying COLLATE pg_catalog."default" NOT NULL,
    c_password character varying COLLATE pg_catalog."default" NOT NULL,
    c_dtcrientidade_nivel_2ao date NOT NULL DEFAULT CURRENT_DATE,
    c_status character(1) COLLATE pg_catalog."default" NOT NULL DEFAULT 'A'::bpchar,
    CONSTRAINT id_banco PRIMARY KEY (id_banco)
) WITH (OIDS = FALSE) TABLESPentidade_nivel_2E pg_default;
ALTER TABLE public.tb_conexao OWNER to postgres;
SET bytea_output = 'escape';
INSERT INTO tb_conexao (
        id_banco,
        c_host,
        c_port,
        c_dbname,
        c_user,
        c_password,
        c_dtcrientidade_nivel_2ao,
        c_status
    )
VALUES (
        1,
        CAST(
            encrypt(CAST('172.16.4.31' AS BYTEA), '#$%!&', 'aes') AS character VARYING
        ),
        CAST(
            encrypt(CAST('5432' AS BYTEA), '#$%!&', 'aes') AS character VARYING
        ),
        CAST(
            encrypt(CAST('"Banco XXX"' AS BYTEA), '#$%!&', 'aes') AS character VARYING
        ),
        CAST(
            encrypt(CAST('dblink' AS BYTEA), '#$%!&', 'aes') AS character VARYING
        ),
        CAST(
            encrypt(CAST('dblink' AS BYTEA), '#$%!&', 'aes') AS character VARYING
        ),
        DEFAULT,
        'A'
    );