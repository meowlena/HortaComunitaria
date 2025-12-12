-- Consultas para Hortas Urbanas Comunitárias
-- Visão + 6 consultas conforme requisitos

-- ========================
-- VISÃO (mínimo 2 tabelas)
-- Resumo operacional de lotes com plantações, manutenção e responsável
-- ========================

CREATE OR REPLACE VIEW vw_lote_resumo_operacional AS
SELECT 
    l.id AS lote_id,
    l.area,
    l.status AS lote_status,
    h.endereco AS horta_endereco,
    -- Responsável atual
    (
        SELECT r.nome
        FROM lote_responsavel lr
        JOIN responsavel r ON lr.id_responsavel = r.id
        WHERE lr.id_lote = l.id AND lr.data_fim IS NULL
        LIMIT 1
    ) AS responsavel_atual,
    -- Espécies plantadas (com status)
    STRING_AGG(
        CONCAT(e.nome, ' (', p.status, ')'),
        ', '
    ) AS especies_plantadas,
    -- Contagem de plantações
    COUNT(DISTINCT p.id_especie) AS total_especies,
    -- Próxima colheita prevista
    MIN(p.previsao) AS proxima_colheita_prevista,
    -- Status geral de colheita
    STRING_AGG(DISTINCT p.status, ', ') AS status_colheita,
    -- Custo total de manutenção
    COALESCE(SUM(m.custo), 0) AS custo_total_manutencao,
    -- Data da última manutenção
    MAX(m.data) AS ultima_manutencao
FROM lote l
JOIN horta h ON l.id_horta = h.id
LEFT JOIN plantio p ON l.id = p.id_lote
LEFT JOIN especie e ON p.id_especie = e.id
LEFT JOIN manutencao m ON l.id = m.id_lote
GROUP BY l.id, l.area, l.status, h.endereco;

-- ========================
-- CONSULTA 1: GROUP BY sem HAVING
-- Contar quantos lotes cada horta possui
-- ========================

SELECT 
    h.id,
    h.endereco,
    COUNT(l.id) AS total_lotes
FROM horta h
LEFT JOIN lote l ON h.id = l.id_horta
GROUP BY h.id, h.endereco
ORDER BY total_lotes DESC;

-- ========================
-- CONSULTA 2: GROUP BY com HAVING
-- Listar espécies que foram plantadas mais de 2 vezes
-- ========================

SELECT 
    e.id,
    e.nome,
    e.categoria,
    COUNT(p.id_especie) AS total_plantios
FROM especie e
LEFT JOIN plantio p ON e.id = p.id_especie
GROUP BY e.id, e.nome, e.categoria
HAVING COUNT(p.id_especie) > 1
ORDER BY total_plantios DESC;

-- ========================
-- CONSULTA 3: Subconsulta
-- Listar lotes cujo custo total de manutenção é maior que a média
-- ========================

SELECT 
    l.id,
    l.area,
    l.status,
    SUM(m.custo) AS custo_total_manutencao
FROM lote l
LEFT JOIN manutencao m ON l.id = m.id_lote
WHERE l.id IN (
    SELECT m2.id_lote
    FROM manutencao m2
    GROUP BY m2.id_lote
    HAVING SUM(m2.custo) > (
        SELECT AVG(custo_total)
        FROM (
            SELECT SUM(custo) AS custo_total
            FROM manutencao
            WHERE custo IS NOT NULL
            GROUP BY id_lote
        ) avg_custos
    )
)
GROUP BY l.id, l.area, l.status
ORDER BY custo_total_manutencao DESC;

-- ========================
-- CONSULTA 4: Subconsulta
-- Responsáveis que participam de eventos e seus lotes associados
-- ========================

SELECT DISTINCT
    r.id,
    r.nome,
    r.contato,
    (
        SELECT COUNT(DISTINCT e.id)
        FROM evento e
        WHERE e.id_responsavel = r.id
    ) AS total_eventos,
    (
        SELECT COUNT(DISTINCT lr.id_lote)
        FROM lote_responsavel lr
        WHERE lr.id_responsavel = r.id AND lr.data_fim IS NULL
    ) AS lotes_ativos
FROM responsavel r
WHERE r.id IN (
    SELECT DISTINCT id_responsavel
    FROM evento
    WHERE id_responsavel IS NOT NULL
)
ORDER BY total_eventos DESC;

-- ========================
-- CONSULTA 5: NOT EXISTS
-- Lotes que NÃO têm registro de manutenção
-- ========================

SELECT 
    l.id,
    l.area,
    l.status,
    h.endereco AS horta_endereco
FROM lote l
JOIN horta h ON l.id_horta = h.id
WHERE NOT EXISTS (
    SELECT 1
    FROM manutencao m
    WHERE m.id_lote = l.id
)
ORDER BY l.id;

-- ========================
-- CONSULTA 6: Usando a Visão
-- Hortas mais ativas com resumo de plantações e manutenção
-- ========================

-- Ver resumo de todos os lotes
SELECT * FROM vw_lote_resumo_operacional;

-- Hortas com mais lotes ativos e detalhes operacionais
SELECT 
    h.id,
    h.endereco AS horta_endereco,
    h.fundado_em,
    COUNT(DISTINCT v.lote_id) AS total_lotes_ativos,
    SUM(v.area) AS area_total,
    SUM(v.total_especies) AS total_especies_plantadas,
    COUNT(DISTINCT v.responsavel_atual) AS responsaveis_envolvidos,
    SUM(v.custo_total_manutencao) AS custo_manutencao_total,
    MAX(v.ultima_manutencao) AS ultima_manutencao_realizada,
    MIN(v.proxima_colheita_prevista) AS proxima_colheita
FROM horta h
JOIN vw_lote_resumo_operacional v ON h.endereco = v.horta_endereco
WHERE v.lote_status = 'ativo'
GROUP BY h.id, h.endereco, h.fundado_em
ORDER BY total_lotes_ativos DESC, custo_manutencao_total DESC;
