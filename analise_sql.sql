-- 1) Quantos chamados foram abertos no dia 01/04/2023? 
-- 1903
SELECT COUNT(*) AS total_chamados
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01';


-- 2) Qual o tipo de chamado que teve mais teve chamados abertos no dia 01/04/2023?
-- Estacionamento irregular 373
SELECT tipo, COUNT(*) AS total_chamados
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01'
GROUP BY tipo
ORDER BY total_chamados DESC
LIMIT 1;


-- 3) Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?
-- 1o Campo Grande 124
-- 2o Tijuca 96
-- 3o Barra da Tijuca 60
SELECT b.nome AS bairro, COUNT(c.id_chamado) AS total_chamados
FROM `datario.adm_central_atendimento_1746.chamado` c
JOIN `datario.dados_mestres.bairro` b ON c.id_bairro = b.id_bairro
WHERE DATE(c.data_inicio) = '2023-04-01'
GROUP BY b.nome
ORDER BY total_chamados DESC
LIMIT 3;


-- 4) Qual o nome da subprefeitura com mais chamados abertos nesse dia?
-- Zona Norte 534
SELECT b.subprefeitura, COUNT(c.id_chamado) AS total_chamados
FROM `datario.adm_central_atendimento_1746.chamado` c
JOIN `datario.dados_mestres.bairro` b ON c.id_bairro = b.id_bairro
WHERE DATE(c.data_inicio) = '2023-04-01'
GROUP BY b.subprefeitura
ORDER BY total_chamados DESC
LIMIT 1;


-- 5) Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece?
-- 131 chamadas
-- Essas chamadas não possuem vínculo com um id_bairro ou subprefeitura,
-- logo podem corresponder a tipos independentes do espaço geográfico.
-- Um exemplo são as demandas do atendimento ao cidadão, como dúvidas,
-- sugestões ou notificações sobre erros e problemas em serviços digitais
-- da prefeitura que não estão vinculadas a um local específico.
SELECT COUNT(*) AS chamados_sem_bairro
FROM `datario.adm_central_atendimento_1746.chamado` c
LEFT JOIN `datario.dados_mestres.bairro` b ON c.id_bairro = b.id_bairro
WHERE DATE(c.data_inicio) = '2023-04-01' AND b.id_bairro IS NULL;


-- 6) Quantos chamados com o ipo "Perturbação do sossego" foram abertos desde 01/01/2022 até 31/12/2023 (incluindo extremidades)?
-- 56785
SELECT COUNT(*) AS total_chamados
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) BETWEEN '2022-01-01' AND '2024-12-31'
  AND id_subtipo = '5071';

-- 7) Selecione os chamados com esse tipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).

-- Seleciona os eventos desejados com datas válidas
WITH eventos AS (
  SELECT evento, 
         DATE(data_inicial) AS data_inicial, 
         DATE(data_final) AS data_final
  FROM `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`
  WHERE data_inicial IS NOT NULL
    AND data_final IS NOT NULL
    AND evento IN ('Réveillon', 'Carnaval', 'Rock in Rio')
),

-- Filtra os chamados do subtipo "Perturbação do sossego"
chamados_filtrados AS (
  SELECT id_chamado, 
         data_inicio, 
         id_subtipo, 
         id_bairro, 
         id_logradouro,
         situacao
  FROM `datario.adm_central_atendimento_1746.chamado`
  WHERE id_subtipo = '5071'
)

-- Relaciona os chamados com os eventos cujo período inclui a data do chamado
SELECT c.id_chamado, 
       c.data_inicio, 
       c.id_subtipo, 
       c.id_bairro, 
       c.id_logradouro, 
       c.situacao,
       e.evento -- anexa o nome do evento correspondente
FROM chamados_filtrados c
JOIN eventos e 
  ON DATE(c.data_inicio) BETWEEN e.data_inicial AND e.data_final 
ORDER BY c.data_inicio;


-- 8) Quantos chamados desse tipo foram abertos em cada evento?
-- 1o Rock in Rio 946
-- 2o Carnaval 252
-- 3o Réveillon 147

-- Seleciona os eventos desejados com datas válidas
WITH eventos AS (
  SELECT evento, 
         DATE(data_inicial) AS data_inicial, 
         DATE(data_final) AS data_final
  FROM `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`
  WHERE data_inicial IS NOT NULL
    AND data_final IS NOT NULL
    AND evento IN ('Réveillon', 'Carnaval', 'Rock in Rio')
),

-- Seleciona apenas a data de chamados subtipo "Perturbação do sossego"
chamados AS (
  SELECT DATE(data_inicio) AS data_chamado
  FROM `datario.adm_central_atendimento_1746.chamado`
  WHERE id_subtipo = '5071'
),

-- Conta quantos chamados ocorreram dentro do intervalo de cada evento
chamados_por_evento AS (
  SELECT e.evento, COUNT(c.data_chamado) AS total_chamados
  FROM eventos e
  LEFT JOIN chamados c 
    ON c.data_chamado BETWEEN e.data_inicial AND e.data_final
  GROUP BY e.evento 
)

-- Retorna o total de chamados por evento, ordenando do maior para o menor
SELECT evento, total_chamados
FROM chamados_por_evento
ORDER BY total_chamados DESC;

-- 9) Qual evento teve a maior média diária de chamados abertos desse tipo?
-- Rock in Rio 135.1428571428...

-- Seleciona os eventos com data inicial e final
WITH eventos AS (
  SELECT evento, 
         DATE(data_inicial) AS data_inicial, 
         DATE(data_final) AS data_final
  FROM `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`
  WHERE data_inicial IS NOT NULL
    AND data_final IS NOT NULL
    AND evento IN ('Réveillon', 'Carnaval', 'Rock in Rio')
),

-- Gera todos os dias entre data_inicial e data_final de cada evento
evento_datas AS (
  SELECT evento, dia
  FROM eventos,
       UNNEST(GENERATE_DATE_ARRAY(data_inicial, data_final)) AS dia
),

-- Conta os chamados por data (apenas do tipo requerido)
chamados_por_data AS (
  SELECT DATE(data_inicio) AS dia, COUNT(*) AS total
  FROM `datario.adm_central_atendimento_1746.chamado`
  WHERE id_subtipo = '5071'
  GROUP BY dia
),

-- Associa cada dia de evento ao total de chamados, incluindo 0 onde não houve chamados
chamados_evento_dia AS (
  SELECT ed.evento, ed.dia, COALESCE(cd.total, 0) AS chamados
  FROM evento_datas ed
  LEFT JOIN chamados_por_data cd 
    ON ed.dia = cd.dia
),

-- Calcula a média diária de chamados por evento
media_diaria_evento AS (
  SELECT evento, AVG(chamados) AS media_diaria
  FROM chamados_evento_dia
  GROUP BY evento
)

-- Retorna o evento com maior média diária
SELECT evento AS evento_com_maior_media, media_diaria
FROM media_diaria_evento
ORDER BY media_diaria DESC
LIMIT 1;


-- 10) Compare as médias diárias de chamados abertos desse tipo durante os eventos específicos (Reveillon, Carnaval e Rock in Rio) e a média diária de chamados abertos desse tipo considerando todo o período de 01/01/2022 até 31/12/2023.
-- Réveillon 24.5
-- Rock in Rio 135.14285714285714...
-- Carnaval 28.0
-- Média Geral 51.81113138686141...

-- Eventos filtrados
WITH eventos AS (
  SELECT evento, 
         DATE(data_inicial) AS data_inicial, 
         DATE(data_final) AS data_final
  FROM `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`
  WHERE data_inicial IS NOT NULL
    AND data_final IS NOT NULL
    AND evento IN ('Réveillon', 'Carnaval', 'Rock in Rio')
),

-- Gera todos os dias de cada evento
evento_datas AS (
  SELECT evento, dia
  FROM eventos,
       UNNEST(GENERATE_DATE_ARRAY(data_inicial, data_final)) AS dia
),

-- Chamados filtrados
chamados_filtrados AS (
  SELECT DATE(data_inicio) AS dia
  FROM `datario.adm_central_atendimento_1746.chamado`
  WHERE id_subtipo = '5071'
    AND DATE(data_inicio) BETWEEN '2022-01-01' AND '2024-12-31'
),

-- Contagem por dia
chamados_por_dia AS (
  SELECT dia, COUNT(*) AS total
  FROM chamados_filtrados
  GROUP BY dia
),

-- Junta os dias de evento com os chamados por data
chamados_evento_dia AS (
  SELECT ed.evento, ed.dia, COALESCE(cd.total, 0) AS chamados
  FROM evento_datas ed
  LEFT JOIN chamados_por_dia cd ON ed.dia = cd.dia
),

-- Média diária por evento (usando todos os dias do evento)
media_eventos AS (
  SELECT evento AS evento, AVG(chamados) AS media_diaria
  FROM chamados_evento_dia
  GROUP BY evento
),

-- Gera todos os dias entre 01/01/2022 e 31/12/2024
datas_completas AS (
  SELECT dia
  FROM UNNEST(GENERATE_DATE_ARRAY('2022-01-01', '2024-12-31')) AS dia
),

-- Junta com os chamados do período
chamados_dias_completos AS (
  SELECT d.dia, COALESCE(c.total, 0) AS chamados
  FROM datas_completas d
  LEFT JOIN chamados_por_dia c ON d.dia = c.dia
),

-- Média geral considerando todos os dias
media_geral AS (
  SELECT 'Média Geral' AS evento, AVG(chamados) AS media_diaria
  FROM chamados_dias_completos
)

-- União do resultado final
SELECT evento, media_diaria
FROM media_geral

UNION ALL

SELECT evento, media_diaria
FROM media_eventos;
