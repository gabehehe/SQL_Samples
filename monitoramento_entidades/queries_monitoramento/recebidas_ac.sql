select nome_entidade, nome_entidade_nivel_2, 
	extrentidade_nivel_2t (year from ts_inicio_periodo) as ano,
	extrentidade_nivel_2t (month from ts_inicio_periodo) as mes, SUM(numero_recebidas) as numero_recebidas from tb_solicitentidade_nivel_2oes_recebidas_entidade_nivel_2 tsra
inner join tb_arquivo_entidade tap on tsra.id_arquivo = tap.id_arquivo
inner join tb_entidade tp on tp.id_entidade = tsra.id_entidade_absoluto
group by nome_entidade, nome_entidade_nivel_2, ano, mes
order by nome_entidade, nome_entidade_nivel_2, ano, mes