import basedosdados as bd
import pandas as pd

query_viz = """
    SELECT
        *
    FROM datario.adm_central_atendimento_1746.chamado tb_chamado
    WHERE DATE(tb_chamado.data_inicio) BETWEEN '2022-01-01' AND '2023-12-31'
"""
df_viz = bd.read_sql(query=query_viz, billing_project_id="secc-rj")

df_viz.to_csv('data_analysis/chamado2.csv', index=False, sep=';', encoding='utf-8-sig')