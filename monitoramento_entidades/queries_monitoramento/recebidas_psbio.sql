select tp.nome_entidade as nome_entidade_origem,  tp2.nome_entidade as nome_entidade_destino,
	extrentidade_nivel_2t (year from ts_inicio_periodo) as ano,
	extrentidade_nivel_2t (month from ts_inicio_periodo) as mes,
	sum(tsrp.numero_processadas) as processadas 
	from tb_solicitentidade_nivel_2oes_recebidas_entidade tsrp
inner join tb_arquivo_entidade tap on tsrp.id_arquivo = tap.id_arquivo
inner join tb_entidade tp on tp.id_entidade = tsrp.id_entidade_absoluto
inner join tb_entidade tp2 on tp2.id_entidade = tsrp.id_entidade_relativo
group by nome_entidade_origem, nome_entidade_destino, ano, mes
order by nome_entidade_origem, nome_entidade_destino, ano, mes