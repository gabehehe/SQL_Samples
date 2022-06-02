select tp.nome_entidade as nome_entidade_origem,  tp2.nome_entidade as nome_entidade_destino,
	extrentidade_nivel_2t (year from ts_inicio_periodo) as ano,
	extrentidade_nivel_2t (month from ts_inicio_periodo) as mes,
	internal_error_code, internal_error_message,
	response_error_code, response_error_message
	from tb_erros_enviados ttpp
inner join tb_arquivo_entidade tap on ttpp.id_arquivo = tap.id_arquivo
inner join tb_entidade tp on tp.id_entidade = ttpp.id_entidade_absoluto
inner join tb_entidade tp2 on tp2.id_entidade = ttpp.id_entidade_destino
group by nome_entidade_origem, nome_entidade_destino, ano, mes, internal_error_code, internal_error_message, response_error_code, response_error_message
order by nome_entidade_origem, nome_entidade_destino, ano, mes