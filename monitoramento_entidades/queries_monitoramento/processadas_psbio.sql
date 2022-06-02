select tp.nome_entidade as nome_entidade_origem,  tp2.nome_entidade as nome_entidade_destino,
	extrentidade_nivel_2t (year from ts_inicio_periodo) as ano,
	extrentidade_nivel_2t (month from ts_inicio_periodo) as mes,
	tot_transentidade_nivel_2 as tipo_transentidade_nivel_2ao, ts_total_transentidade_nivel_2ao
	from tb_transentidade_nivel_2_processadas_entidade ttpp
inner join tb_arquivo_entidade tap on ttpp.id_arquivo = tap.id_arquivo
inner join tb_entidade tp on tp.id_entidade = ttpp.id_entidade_origem
inner join tb_entidade tp2 on tp2.id_entidade = ttpp.id_entidade_destino
group by nome_entidade_origem, nome_entidade_destino, ano, mes, tot_transentidade_nivel_2, ts_total_transentidade_nivel_2ao
order by nome_entidade_origem, nome_entidade_destino, ano, mes, tot_transentidade_nivel_2, ts_total_transentidade_nivel_2ao