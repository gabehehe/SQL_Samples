-- FUNCTION: public.f_insert_aut()
-- DROP FUNCTION public.f_insert_aut();
CREATE OR REPLentidade_nivel_2E FUNCTION public.f_insert_aut() RETURNS void LANGUAGE 'plpgsql' COST 100 VOLATILE PARALLEL UNSAFE AS $BODY$
DECLARE v_select_info_aut_"Banco XXX" character VARYING;
v_aut_faltantes INTEGER;
cursorAutFaltantes CURSOR FOR
SELECT public.f_get_aut_faltantes()
ORDER BY f_get_aut_faltantes;
BEGIN OPEN cursorAutFaltantes;
LOOP FETCH cursorAutFaltantes INTO v_aut_faltantes;
EXIT
WHEN NOT FOUND;
v_select_info_aut_"Banco XXX" := 'SELECT ta.aut_cod,
    [...]]';
IF NOT EXISTS(
    SELECT DISTINCT aut_codigo
    FROM auditoria.tb_autoridade
    WHERE aut_codigo = v_aut_faltantes
) THEN BEGIN LOCK TABLE auditoria.tb_autoridade IN entidade_nivel_2CESS EXCLUSIVE MODE;
INSERT INTO auditoria.tb_autoridade
SELECT aut_cod,
    pju_cnpj,
    pju_nom,
    aut_nom,
    aut_dt_credenciamento,
    t_aut_cod
FROM DBLINK(
        f_conexao_"Banco XXX"(1)::text,
        v_select_info_aut_"Banco XXX"::text
    ) AS (
        aut_cod integer,
        pju_cnpj character varying(15),
        pju_nom character varying(500),
        aut_nom character varying(500),
        aut_dt_credenciamento date,
        t_aut_cod smallint
    )
ORDER BY aut_cod;
end;
end if;
end loop;
CLOSE cursorAutFaltantes;
END;
$BODY$;
ALTER FUNCTION public.f_insert_aut() OWNER TO postgres;