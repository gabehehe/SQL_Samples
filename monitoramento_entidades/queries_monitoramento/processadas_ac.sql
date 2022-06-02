select nome_entidade, entidade_nivel_2_origem, 
	extrentidade_nivel_2t (year from ts_inicio_periodo) as ano,
	extrentidade_nivel_2t (month from ts_inicio_periodo) as mes, count(referencia_transentidade_nivel_2ao) as numero_transentidade_nivel_2oes
	from tb_transentidade_nivel_2_processadas_entidade_nivel_2 tsra
inner join tb_arquivo_entidade tap on tsra.id_arquivo = tap.id_arquivo
inner join tb_entidade tp on tp.id_entidade = tsra.id_entidade_absoluto
group by nome_entidade, entidade_nivel_2_origem, ano, mes
order by nome_entidade, entidade_nivel_2_origem, ano, mes