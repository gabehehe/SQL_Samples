-- Script de migração das autoridades do Banco XXXX para o Sistema XXXX (data do banco de dados XXX: 26/05/2022)

BEGIN TRANSACTION;
-- ##########################
-- ###AUTORIDADE VINCULADA###
-- ##########################
DELETE FROM schema_x.tb_autoridade_vinculada WHERE aut_cod_propria IN (
-- selecionando todas as autoridades vinculadas propria que não estão associadas a ocorrências.
SELECT aut_cod_propria
	FROM schema_x.tb_autoridade_vinculada
		WHERE aut_cod_propria NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod_propria NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
DELETE FROM schema_x.tb_autoridade_vinculada WHERE aut_cod_pai IN (
-- selecionando todas as autoridades vinculadas pai que não estão associadas a ocorrências.
SELECT aut_cod_pai
	FROM schema_x.tb_autoridade_vinculada
		WHERE aut_cod_pai NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod_pai NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
-- ##############################
-- #AUTORIDADE POSSUI SITUACAOAO#
-- ##############################
-- selecionando todas as autoridades com SITUACAOao que não estão associadas a ocorrências.
DELETE FROM schema_x.tb_aut_possui_sit WHERE aut_cod IN (
SELECT aut_cod
	FROM schema_x.tb_aut_possui_sit
		WHERE aut_cod NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
-- ##########################
-- AUTORIDADE POSSUI OID
-- ##########################
-- selecionando todas as autoridades com OID que não estão associadas a ocorrências.
DELETE FROM schema_x.tb_aut_possui_oid WHERE aut_cod IN (
SELECT aut_cod
	FROM schema_x.tb_aut_possui_oid
		WHERE aut_cod NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
-- ##########################
-- AUTORIDADE POSSUI SITUACAOAO DO PROCESSO
-- ##########################
-- selecionando todas as autoridades com situação do processo que não estão associadas a ocorrências.
DELETE FROM schema_x.tb_aut_possui_sitproc WHERE aut_cod IN (
SELECT aut_cod
	FROM schema_x.tb_aut_possui_sitproc
		WHERE aut_cod NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
-- ##########################
-- AUTORIDADE tb_itecaut_possui_t_itec
-- ##########################
-- selecionando todas as tb_itecaut_possui_t_itec que não estão associadas a ocorrências.
DELETE FROM schema_x.tb_itecaut_possui_t_itec WHERE itecaut_cod IN (
SELECT itecaut_cod
	FROM schema_x.tb_itecaut_possui_t_itec
		WHERE itecaut_cod IN (
			SELECT itecaut_cod
				FROM schema_x.tb_itec_possui_aut
					WHERE aut_cod NOT IN (
						SELECT aut_cod_ar FROM objeto.tb_ocorrencia
							WHERE aut_cod_ar IS NOT NULL
					)
					AND aut_cod NOT IN (
						SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
							WHERE aut_cod_entidade_nivel_2 IS NOT NULL
					)
			)

);
-- ##########################
-- AUTORIDADE POSSUI IT
-- ##########################
-- selecionando todas as autoridades com IT que não estão associadas a ocorrências.
DELETE FROM schema_x.tb_itec_possui_aut WHERE aut_cod IN (
SELECT aut_cod
	FROM schema_x.tb_itec_possui_aut
		WHERE aut_cod NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
DELETE FROM schema_x.tb_pss_possui_aut;
-- ##########################
-- AUTORIDADE (AR)
-- ##########################
DELETE FROM schema_x.tb_autoridade WHERE aut_cod IN (
--selecionando todas as ARS que não tem ocorrencia.
SELECT TB_AUT.aut_cod
	FROM schema_x.tb_autoridade TB_AUT
		WHERE TB_AUT.t_aut_cod = 12
		AND TB_AUT.aut_cod NOT IN (
				SELECT aut_cod FROM seguranca.tb_computador
					WHERE aut_cod IS NOT NULL
			)  
			AND TB_AUT.aut_cod NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
);

-- ##########################
-- AUTORIDADE (entidade_nivel_2/entidade_nivel_2T)
-- ##########################
DELETE FROM schema_x.tb_autoridade WHERE aut_cod IN (
--selecionando todas as entidade_nivel_2S que não tem ocorrencia.
SELECT TB_AUT.aut_cod
	FROM schema_x.tb_autoridade TB_AUT
		WHERE TB_AUT.t_aut_cod != 12 AND TB_AUT.t_aut_cod != 0
			AND TB_AUT.aut_cod NOT IN (
				SELECT aut_cod FROM seguranca.tb_computador
					WHERE aut_cod IS NOT NULL
			)
			AND TB_AUT.aut_cod NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
			
);

-- FASE 2
-- criando tabela temporaria para manter dados da autoridade
CREATE TABLE schema_x.tb_autoridade_tmp
(
  aut_tmp_cod serial NOT NULL, -- chave primária da tabela autoridade
  aut_cod serial NOT NULL, -- chave primária da tabela autoridade
  t_aut_cod bigint DEFAULT 99,
  aut_nom character varying(255) NOT NULL, -- nome da autoridade objetora
  aut_dt_cadastro timestamp with time zone -- data de cadastro
);

--inserir dados na tabela temporaria
INSERT INTO schema_x.tb_autoridade_tmp (aut_nom, aut_cod,t_aut_cod,aut_dt_cadastro)
SELECT DISTINCT ON (aut_nom) aut_nom, aut_cod, t_aut_cod, aut_dt_cadastro
	FROM schema_x.tb_autoridade
		WHERE t_aut_cod = 12
			AND aut_cod IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
			ORDER BY aut_nom, aut_cod ASC;

INSERT INTO schema_x.tb_autoridade_tmp (aut_nom, aut_cod,t_aut_cod,aut_dt_cadastro)
-- selecionando todas as entidade_nivel_2S que tem ocorrencias com autoridades duplicadas.
SELECT DISTINCT ON (TB_AUT.aut_nom) TB_AUT.aut_nom, TB_AUT.aut_cod, TB_AUT.t_aut_cod, TB_AUT.aut_dt_cadastro
	FROM schema_x.tb_autoridade TB_AUT
		WHERE TB_AUT.t_aut_cod != 12 AND TB_AUT.t_aut_cod != 0
			AND TB_AUT.aut_cod IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
			ORDER BY TB_AUT.aut_nom, TB_AUT.aut_cod ASC;

-- update das ocorrencias para liberar as entidade_nivel_2s duplicadas para exclusão.
UPDATE objeto.tb_ocorrencia SET aut_cod_entidade_nivel_2=subquery_autoridade.aut_cod_matriz
	FROM ( 
		SELECT AUT.aut_cod as aut_cod_excluir,AUT_TMP.aut_cod as aut_cod_matriz
			FROM schema_x.tb_autoridade AUT
			INNER JOIN schema_x.tb_autoridade_tmp AUT_TMP ON (AUT.aut_nom=AUT_TMP.aut_nom)
				WHERE AUT.aut_cod NOT IN (
					SELECT aut_cod
						FROM schema_x.tb_autoridade_tmp 
							WHERE t_aut_cod != 12 AND t_aut_cod != 0
								AND aut_cod IN (
									SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
										WHERE aut_cod_entidade_nivel_2 IS NOT NULL
								)
								ORDER BY aut_nom, aut_cod ASC
							)
				AND AUT.t_aut_cod != 12 AND AUT.t_aut_cod != 0
		) AS subquery_autoridade
	WHERE objeto.tb_ocorrencia.aut_cod_entidade_nivel_2 = subquery_autoridade.aut_cod_excluir;

-- update das ocorrencias para liberar as ars duplicadas para exclusão.
UPDATE objeto.tb_ocorrencia SET aut_cod_ar=subquery_autoridade.aut_cod_matriz
	FROM ( 
		SELECT AUT.aut_cod as aut_cod_excluir,AUT_TMP.aut_cod as aut_cod_matriz
			FROM schema_x.tb_autoridade AUT
			INNER JOIN schema_x.tb_autoridade_tmp AUT_TMP ON (AUT.aut_nom=AUT_TMP.aut_nom)
				WHERE AUT.aut_cod NOT IN (
					SELECT aut_cod
						FROM schema_x.tb_autoridade_tmp 
							WHERE t_aut_cod = 12
								AND aut_cod IN (
									SELECT aut_cod_ar FROM objeto.tb_ocorrencia
										WHERE aut_cod_ar IS NOT NULL
								)
								ORDER BY aut_nom, aut_cod ASC
							)
				AND AUT.t_aut_cod = 12
		) AS subquery_autoridade
	WHERE objeto.tb_ocorrencia.aut_cod_ar = subquery_autoridade.aut_cod_excluir;

DROP TABLE schema_x.tb_autoridade_tmp;

-- FASE 3, Excluindo as autoridades que foram retiradas da duplicidade das ocorrências.

-- ##########################
-- AUTORIDADE VINCULADA
-- ##########################
DELETE FROM schema_x.tb_autoridade_vinculada WHERE aut_cod_propria IN (
-- selecionando todas as autoridades vinculadas propria que não estão associadas a ocorrências.
SELECT aut_cod_propria
	FROM schema_x.tb_autoridade_vinculada
		WHERE aut_cod_propria NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod_propria NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
DELETE FROM schema_x.tb_autoridade_vinculada WHERE aut_cod_pai IN (
-- selecionando todas as autoridades vinculadas pai que não estão associadas a ocorrências.
SELECT aut_cod_pai
	FROM schema_x.tb_autoridade_vinculada
		WHERE aut_cod_pai NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod_pai NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
-- ##########################
-- AUTORIDADE POSSUI SITUACAOAO
-- ##########################
-- selecionando todas as autoridades com SITUACAOao que não estão associadas a ocorrências.
DELETE FROM schema_x.tb_aut_possui_sit WHERE aut_cod IN (
SELECT aut_cod
	FROM schema_x.tb_aut_possui_sit
		WHERE aut_cod NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
-- ##########################
-- AUTORIDADE POSSUI OID
-- ##########################
-- selecionando todas as autoridades com OID que não estão associadas a ocorrências.
DELETE FROM schema_x.tb_aut_possui_oid WHERE aut_cod IN (
SELECT aut_cod
	FROM schema_x.tb_aut_possui_oid
		WHERE aut_cod NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
-- ##########################
-- AUTORIDADE POSSUI SITUACAOAO DO PROCESSO
-- ##########################
-- selecionando todas as autoridades com situação do processo que não estão associadas a ocorrências.
DELETE FROM schema_x.tb_aut_possui_sitproc WHERE aut_cod IN (
SELECT aut_cod
	FROM schema_x.tb_aut_possui_sitproc
		WHERE aut_cod NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
-- ##########################
-- AUTORIDADE tb_itecaut_possui_t_itec
-- ##########################
-- selecionando todas as tb_itecaut_possui_t_itec que não estão associadas a ocorrências.
DELETE FROM schema_x.tb_itecaut_possui_t_itec WHERE itecaut_cod IN (
SELECT itecaut_cod
	FROM schema_x.tb_itecaut_possui_t_itec
		WHERE itecaut_cod IN (
			SELECT itecaut_cod
				FROM schema_x.tb_itec_possui_aut
					WHERE aut_cod NOT IN (
						SELECT aut_cod_ar FROM objeto.tb_ocorrencia
							WHERE aut_cod_ar IS NOT NULL
					)
					AND aut_cod NOT IN (
						SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
							WHERE aut_cod_entidade_nivel_2 IS NOT NULL
					)
			)

);
-- ##########################
-- AUTORIDADE POSSUI IT
-- ##########################
-- selecionando todas as autoridades com IT que não estão associadas a ocorrências.
DELETE FROM schema_x.tb_itec_possui_aut WHERE aut_cod IN (
SELECT aut_cod
	FROM schema_x.tb_itec_possui_aut
		WHERE aut_cod NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
		AND aut_cod NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
);
DELETE FROM schema_x.tb_pss_possui_aut;
-- ##########################
-- AUTORIDADE (AR)
-- ##########################
DELETE FROM schema_x.tb_autoridade WHERE aut_cod IN (
--selecionando todas as ARS que não tem ocorrencia.
SELECT TB_AUT.aut_cod
	FROM schema_x.tb_autoridade TB_AUT
		WHERE TB_AUT.t_aut_cod = 12
		AND TB_AUT.aut_cod NOT IN (
				SELECT aut_cod FROM seguranca.tb_computador
					WHERE aut_cod IS NOT NULL
			)  
			AND TB_AUT.aut_cod NOT IN (
				SELECT aut_cod_ar FROM objeto.tb_ocorrencia
					WHERE aut_cod_ar IS NOT NULL
			)
);

-- ##########################
-- AUTORIDADE (entidade_nivel_2/entidade_nivel_2T)
-- ##########################
DELETE FROM schema_x.tb_autoridade WHERE aut_cod IN (
--selecionando todas as entidade_nivel_2S que não tem ocorrencia.
SELECT TB_AUT.aut_cod
	FROM schema_x.tb_autoridade TB_AUT
		WHERE TB_AUT.t_aut_cod != 12 AND TB_AUT.t_aut_cod != 0
			AND TB_AUT.aut_cod NOT IN (
				SELECT aut_cod FROM seguranca.tb_computador
					WHERE aut_cod IS NOT NULL
			)
			AND TB_AUT.aut_cod NOT IN (
				SELECT aut_cod_entidade_nivel_2 FROM objeto.tb_ocorrencia
					WHERE aut_cod_entidade_nivel_2 IS NOT NULL
			)
			
);

-- FASE 4, Populando base Banco XXX no Sistema XXX

CREATE SCHEMA migrentidade_nivel_2ao_dafn_saf AUTHORIZATION webuser;
       
SET search_path = migrentidade_nivel_2ao_dafn_saf, pg_catalog;

SET default_tablespentidade_nivel_2e = '';

SET default_with_oids = false;

CREATE TABLE tb_aut_possui_sit (
    autsit_cod integer NOT NULL,
    sit_cod integer NOT NULL,
    aut_cod integer NOT NULL,
    autsit_dt_cadastro timestamp without time zone DEFAULT now() NOT NULL,
    autsit_flg_bloqueado boolean DEFAULT false,
    autsit_comentario character varying(500),
    usu_cod integer NOT NULL,
    CONSTRAINT ckc_sit_cod_tb_aut_p CHECK (((sit_cod IS NULL) OR ((sit_cod >= 1000) AND (sit_cod <= 9999))))
);

CREATE TABLE tb_autoridade (
    aut_cod integer NOT NULL,
    pju_cnpj character varying(14),
    t_aut_cod integer DEFAULT 99,
    aut_nom character varying(255) NOT NULL,
    aut_dt_credenciamento date,
    aut_url_site character varying(255),
    aut_flg_bloqueado boolean DEFAULT false,
    aut_cod_old bigint,
    aut_cod_pai_old bigint,
    aut_chave_migrentidade_nivel_2ao bigint,
    pju_cod integer,
    aut_dt_cadastro timestamp with time zone,
    usu_cod integer NOT NULL,
    aut_cod_remoto integer,
    aut_flg_webservice boolean DEFAULT false,
    aut_flg_bloqueado_ws boolean DEFAULT false,
    CONSTRAINT ckc_t_aut_cod_tb_autor CHECK (((t_aut_cod IS NULL) OR ((t_aut_cod >= 0) AND (t_aut_cod <= 99))))
);

CREATE TABLE tb_autoridade_vinculada (
    autvin_cod integer NOT NULL,
    usu_cod bigint NOT NULL,
    aut_cod_pai integer,
    aut_cod_propria integer,
    autvin_dt_cadastro timestamp without time zone DEFAULT now() NOT NULL,
    autvin_flg_bloqueado boolean DEFAULT false,
    autvin_flg_original boolean DEFAULT false
);

--###############################
--#INSERIR DADOS CONFORME MODELO#
--###############################

--#####TB AUTORIDADE#######

--INSERT INTO tb_autoridade (aut_cod, pju_cnpj, t_aut_cod, aut_nom, aut_dt_credenciamento, aut_url_site, aut_flg_bloqueado, aut_cod_old, aut_cod_pai_old, aut_chave_migrentidade_nivel_2ao, pju_cod, aut_dt_cadastro, usu_cod, aut_cod_remoto, aut_flg_webservice, aut_flg_bloqueado_ws) VALUES (7799,NULL,12,'ARXXXX','2019-01-09',NULL,false,NULL,NULL,NULL,1337,'2019-01-02 13:37:13.689-02',86,NULL,true,false);

--#####TB AUTORIDADE VINCULADAS#####

--INSERT INTO tb_autoridade_vinculada (autvin_cod, usu_cod, aut_cod_pai, aut_cod_propria, autvin_dt_cadastro, autvin_flg_bloqueado, autvin_flg_original) VALUES (9671,86,6198,6195,'2006-08-05 00:00:00',false,true);

--######TB AUTORIDADE POSSUI SITUACAOAO#####

--INSERT INTO tb_aut_possui_sit (autsit_cod, sit_cod, aut_cod, autsit_dt_cadastro, autsit_flg_bloqueado, autsit_comentario, usu_cod) VALUES (11380,4006,6201,'2006-02-23 00:00:00',false,NULL,86);



-- FASE FINAL

-- atualizando a tabela de autoridades já existentes, codigo remoto para manter webservice.
UPDATE schema_x.tb_autoridade SET aut_cod_remoto=subquery_aut_migrentidade_nivel_2ao.aut_cod_matriz 
	FROM (
		SELECT AUT.aut_cod,AUT.aut_nom,AUT.aut_cod_remoto,AUT_M.aut_cod aut_cod_matriz,AUT_M.aut_nom as aut_nom_matriz
			FROM schema_x.tb_autoridade AUT
			INNER JOIN migrentidade_nivel_2ao_dafn_saf.tb_autoridade AUT_M ON (AUT.aut_nom=AUT_M.aut_nom)
		) AS subquery_aut_migrentidade_nivel_2ao
	WHERE schema_x.tb_autoridade.aut_nom = subquery_aut_migrentidade_nivel_2ao.aut_nom_matriz;

-- atualizando a tabela de autoridades já existentes, nome das autoridades que mudaram de nome.
UPDATE schema_x.tb_autoridade SET aut_nom=subquery_aut_migrentidade_nivel_2ao.aut_nom_matriz
    FROM (
        SELECT AUT.aut_cod, AUT.aut_nom, AUT.aut_cod_remoto, AUT_M.aut_cod aut_cod_matriz, AUT_M.aut_nom aut_nom_matriz
            FROM schema_x.tb_autoridade AUT
            INNER JOIN migrentidade_nivel_2ao_dafn_saf.tb_autoridade AUT_M ON AUT_M.aut_cod = AUT.aut_cod_remoto
            WHERE AUT.aut_nom NOT LIKE AUT_M.aut_nom
    	) AS subquery_aut_migrentidade_nivel_2ao
    WHERE schema_x.tb_autoridade.aut_cod_remoto = subquery_aut_migrentidade_nivel_2ao.aut_cod_matriz;

-- inserindo os registros restantes.
INSERT INTO schema_x.tb_autoridade(pju_cnpj, t_aut_cod, aut_nom, aut_dt_credenciamento, 
            aut_url_site, aut_flg_bloqueado, aut_cod_old, aut_cod_pai_old, 
            aut_chave_migrentidade_nivel_2ao, pju_cod, aut_dt_cadastro, usu_cod, aut_cod_remoto)
            
SELECT AUT.pju_cnpj, AUT.t_aut_cod, AUT.aut_nom, AUT.aut_dt_credenciamento, 
            AUT.aut_url_site, AUT.aut_flg_bloqueado, AUT.aut_cod_old, AUT.aut_cod_pai_old, 
            AUT.aut_chave_migrentidade_nivel_2ao, AUT.pju_cod, AUT.aut_dt_cadastro, AUT.usu_cod, AUT.aut_cod as aut_cod_remoto
	FROM migrentidade_nivel_2ao_dafn_saf.tb_autoridade AUT
		WHERE AUT.aut_cod NOT IN (
				SELECT aut_cod_remoto FROM schema_x.tb_autoridade
					WHERE aut_cod_remoto IS NOT NULL
			);

DELETE FROM schema_x.tb_autoridade_vinculada;

INSERT INTO schema_x.tb_autoridade_vinculada (aut_cod_pai,aut_cod_propria,autvin_flg_bloqueado,usu_cod)
SELECT AUT_1.aut_cod as aut_cod_pai, AUT_2.aut_cod as aut_cod_propria,AUT_M.autvin_flg_bloqueado,AUT_1.usu_cod
	FROM migrentidade_nivel_2ao_dafn_saf.tb_autoridade_vinculada AUT_M
	JOIN schema_x.tb_autoridade AUT_1 ON (AUT_1.aut_cod_remoto=AUT_M.aut_cod_pai)
	JOIN schema_x.tb_autoridade AUT_2 ON (AUT_2.aut_cod_remoto=AUT_M.aut_cod_propria);


--SITUACAOao da autoridade
DELETE FROM schema_x.tb_aut_possui_sit;
INSERT INTO schema_x.tb_aut_possui_sit (sit_cod,aut_cod,autsit_flg_bloqueado,usu_cod)
SELECT AUT_M.sit_cod,  AUT_1.aut_cod,  AUT_M.autsit_flg_bloqueado, AUT_1.usu_cod
	FROM migrentidade_nivel_2ao_dafn_saf.tb_aut_possui_sit AUT_M
	JOIN schema_x.tb_autoridade AUT_1 ON (AUT_1.aut_cod_remoto=AUT_M.aut_cod);

-- Atualiza pessoas juridicas e usuários 
UPDATE schema_x.tb_autoridade SET pju_cod = null;
UPDATE schema_x.tb_autoridade SET usu_cod = 86; -- user entidade_nivel_2 RAIZ


DROP TABLE migrentidade_nivel_2ao_dafn_saf.tb_aut_possui_sit;
DROP TABLE migrentidade_nivel_2ao_dafn_saf.tb_autoridade_vinculada;
DROP TABLE migrentidade_nivel_2ao_dafn_saf.tb_autoridade;
DROP SCHEMA migrentidade_nivel_2ao_dafn_saf;

COMMIT;
-- Fim do script