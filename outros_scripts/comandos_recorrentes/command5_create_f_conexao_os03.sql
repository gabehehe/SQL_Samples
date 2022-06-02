-- FUNCTION: public.f_conexao_"Banco XXX"(integer)
-- DROP FUNCTION public.f_conexao_"Banco XXX"(integer);
CREATE OR REPLentidade_nivel_2E FUNCTION public.f_conexao_"Banco XXX"(integer) RETURNS character varying LANGUAGE 'plpgsql' COST 100 VOLATILE PARALLEL UNSAFE AS $BODY$
DECLARE v_id_banco ALIAS FOR $1;
v_conexao character VARYING;
BEGIN
SET bytea_output = 'escape';
v_conexao := (
    SELECT 'host = ' || CAST (
            decrypt(c_host::bytea, '#$%!&', 'aes') AS character VARYING
        ) || '
	    port = ' || CAST (
            decrypt(c_port::bytea, '#$%!&', 'aes') AS character VARYING
        ) || ' 
	    dbname	= ' || CAST (
            decrypt(c_dbname::bytea, '#$%!&', 'aes') AS character VARYING
        ) || '
	    user = ' || CAST (
            decrypt(c_user::bytea, '#$%!&', 'aes') AS character VARYING
        ) || '  
	    password = ' || CAST (
            decrypt(c_password::bytea, '#$%!&', 'aes') AS character VARYING
        ) || ''
    FROM public.tb_conexao
    WHERE id_banco = v_id_banco
        and c_status = 'A'
);
RETURN v_conexao;
END;
$BODY$;
ALTER FUNCTION public.f_conexao_"Banco XXX"(integer) OWNER TO postgres;