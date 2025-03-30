# Desafio Técnico - Cientista de Dados Júnior

## Descrição do Projeto
Este repositório contém a minha solução para o Desafio Técnico de Cientista de Dados Júnior, que envolve análise de dados públicos da cidade do Rio de Janeiro utilizando SQL (BigQuery), Python (pandas + basedosdados), APIs públicas e visualização de dados no Tableau.

O projeto está dividido em quatro partes principais:

1. Consultas SQL - Análises utilizando Google BigQuery.
2. Análises com Python - Uso da biblioteca basedosdados para manipulação de dados.
3. Consumo de APIs - Extração de informações via requisições HTTP.
4. Dashboard - Visualização interativa dos dados.

## Configuração do Ambiente

1. Configuração do Google Cloud (BigQuery).

Para executar as consultas SQL, é necessário:

* Criar um projeto no Google Cloud com billing ativado.
* Conectar ao BigQuery e acessar os datasets públicos listados no desafio.
* Rodar as queries no ambiente do BigQuery (salvas no `analise_sql.sql`) ou via basedosdados no Python (`analise_python.ipynb`).

2. Instalação das Dependências

As bibliotecas necessárias para rodar os scripts Python estão listadas no arquivo `requirements.txt`. Para instalá-las, execute:

```
pip install -r requirements.txt
```

### 1. Desafio SQL - BigQuery
As consultas SQL foram escritas diretamente no ambiente do Google BigQuery. As respostas para cada pergunta estão organizadas no arquivo `analise_sql.sql`.

- Como executar as queries:
    - Acesse o Google BigQuery no console do GCP.
    - Conecte-se ao projeto associado à sua conta.
    - Copie e cole as queries do arquivo analise_sql.sql no editor do BigQuery e execute-as.

### 2. Análises com Python
As consultas em Python foram feitas utilizando a biblioteca `basedosdados`, que permite acessar o BigQuery diretamente via código.

- Como executar:
    - Instale as dependências (`requirements.txt`).
    - Abra o analise_python.ipynb e execute os chunks.
    - Certifique-se de ter configurado as credenciais do GCP para acessar o BigQuery.

### 3. Consumo de APIs Públicas
As respostas para as perguntas sobre APIs foram obtidas via requisições HTTP. O código está disponível no arquivo `analise_api.ipynb`.

- Como executar:
    - Instale as dependências (requirements.txt).
    - Rode o script `analise_api.ipynb`.
    - As respostas serão geradas automaticamente com base nas APIs consultadas.

### 4. Visualização de Dados
Para tornar as informações mais acessíveis, criei um dashboard interativo no Tableau.

- Como visualizar o dashboard:
    - Basta acessar os links abaixo:
        - Para a primeira visualização mais holística e sintética dos dados [clique aqui](https://public.tableau.com/app/profile/matheus.santos4843/viz/Desafio_Viz_Qtd/Histria1?publish=yes)
        - Para a primeira visualização geográfica dos dados [clique aqui](https://public.tableau.com/app/profile/matheus.santos4843/viz/Desafio_Viz_Maps/Histria2?publish=yes)


# Conclusão
Este projeto demonstra minha capacidade de manipular dados, realizar análises exploratórias, consumir APIs e criar dashboards interativos. O desafio foi estruturado para testar habilidades práticas em SQL, Python e ferramentas de visualização, essenciais para a atuação como Cientista de Dados Júnior.

# Observações

- Os dados para visualização no tableau consideram todos chamados da base 1746, sem nenhum dado adicional, entre as datas 01/01/2022 até 31/12/2023.

- O Tableau Public não possui integração direta com o Google Cloud; contudo, disponibiliza um repositório online onde é possível publicar visualizações de forma acessível ao público. Caso haja interesse em acessar a visualização localmente deve-se:
    - Executar o script `dados_gcp.py`, localizado na pasta `data_analysis`. 
        - Esse procedimento realizará o download dos dados necessários para o diretório adequado. 
    - Em seguida, basta abrir o arquivo `Desafio_Viz.twb` no Tableau Public. 
- Dessa forma, será possível explorar integralmente o processo de criação das visualizações, desde que o Tableau Public esteja previamente instalado na máquina local.