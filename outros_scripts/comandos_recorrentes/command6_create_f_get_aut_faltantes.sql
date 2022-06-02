-- FUNCTION: public.f_get_aut_faltantes()
-- DROP FUNCTION public.f_get_aut_faltantes();
CREATE OR REPLentidade_nivel_2E FUNCTION public.f_get_aut_faltantes() RETURNS TABLE(f_get_aut_faltantes integer) LANGUAGE 'plpgsql' COST 100 STABLE PARALLEL UNSAFE ROWS 1000 AS $BODY$
DECLARE v_select_aut_"Banco XXX" character VARYING;
BEGIN v_select_aut_"Banco XXX" := '';
RETURN QUERY WITH db_auditoria_sample AS (
    SELECT aut_codigo AS codigo_autoridade_sample
    FROM auditoria.tb_autoridade
    GROUP BY codigo_autoridade_sample
    ORDER BY codigo_autoridade_sample
),
"Banco XXX"_autoridade AS (
    SELECT codigo_autoridade_"Banco XXX"
    FROM DBLINK(
            f_conexao_"Banco XXX"(1)::text,
            v_select_aut_"Banco XXX"::text
        ) AS (codigo_autoridade_"Banco XXX" int)
)
SELECT codigo_autoridade_"Banco XXX"
FROM "Banco XXX"_autoridade
EXCEPT
SELECT codigo_autoridade_sample
FROM db_auditoria_sample;
END;
$BODY$;
ALTER FUNCTION public.f_get_aut_faltantes() OWNER TO postgres;