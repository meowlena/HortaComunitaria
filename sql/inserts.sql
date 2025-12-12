-- Dados fictícios para Hortas Urbanas Comunitárias
-- 3 instâncias por entidade

-- ========================
-- Horta (3 instâncias)
-- ========================
INSERT INTO horta (id, endereco, fundado_em) VALUES
(1, 'Rua das Flores, 123 - Bairro Centro, Porto Alegre', '2020-05-15'),
(2, 'Avenida Brasil, 456 - Bairro Moinhos de Vento, Porto Alegre', '2021-03-22'),
(3, 'Rua Independência, 789 - Bairro Menino Deus, Porto Alegre', '2022-07-10');

-- ========================
-- Responsavel (supertype - 3 instâncias)
-- ========================
INSERT INTO responsavel (id, nome, endereco, contato) VALUES
(1, 'João Silva', 'Rua A, 100', '(51) 98888-1111'),
(2, 'Maria Santos', 'Rua B, 200', '(51) 99999-2222'),
(3, 'Pedro Costa', 'Rua C, 300', '(51) 97777-3333');

-- ========================
-- Pessoa_fisica (3 instâncias - subtipo)
-- ========================
INSERT INTO pessoa_fisica (id, cpf) VALUES
(1, '123.456.789-00'),
(2, '987.654.321-11'),
(3, '555.666.777-22');

-- ========================
-- Instituicao (3 instâncias - subtipo)
-- ========================
-- Nota: inserir responsáveis institucionais adicionais primeiro
INSERT INTO responsavel (id, nome, endereco, contato) VALUES
(4, 'Associação Verde', 'Av. Paulista, 1000', '(51) 3333-4444'),
(5, 'Cooperativa Agroecológica', 'Rua Verde, 500', '(51) 3333-5555'),
(6, 'Instituto Sustentabilidade', 'Av. Getúlio, 2000', '(51) 3333-6666');

INSERT INTO instituicao (id, cnpj, nome_representante) VALUES
(4, '12.345.678/0001-90', 'Carla Oliveira'),
(5, '98.765.432/0001-01', 'Roberto Alves'),
(6, '55.555.666/0001-77', 'Fernanda Martins');

-- ========================
-- Lote (3 instâncias)
-- ========================
INSERT INTO lote (id, id_horta, area, status) VALUES
(1, 1, 50.00, 'ativo'),
(2, 1, 45.50, 'ativo'),
(3, 2, 60.25, 'ativo'),
(4, 2, 55.00, 'inativo'),
(5, 3, 40.75, 'ativo'),
(6, 3, 35.50, 'manutencao');

-- ========================
-- Especie (3 instâncias)
-- ========================
INSERT INTO especie (id, nome, categoria, toxica) VALUES
(1, 'Tomate', 'Alimenticia', false),
(2, 'Alface', 'Alimenticia', false),
(3, 'Girassol', 'Ornamental', false),
(4, 'Arruda', 'Repelente', true),
(5, 'Bertalha', 'PANC', false),
(6, 'Rosa', 'Ornamental', false);

-- ========================
-- Evento (3 instâncias)
-- ========================
INSERT INTO evento (id, id_responsavel, id_horta, nome, data) VALUES
(1, 1, 1, 'Plantio Coletivo de Tomates', '2025-09-15'),
(2, 2, 2, 'Workshop de Compostagem', '2025-10-05'),
(3, 3, 3, 'Colheita Comunitária', '2025-10-20');

-- ========================
-- Lote_Responsavel (N:N com atributo - 3+ instâncias)
-- ========================
INSERT INTO lote_responsavel (id_lote, id_responsavel, data_inicio, data_fim) VALUES
(1, 1, '2023-01-01', NULL),
(2, 2, '2023-06-15', NULL),
(3, 3, '2022-03-10', '2025-03-10'),
(4, 1, '2025-04-01', NULL),
(5, 2, '2023-11-01', NULL),
(6, 4, '2025-05-15', NULL);

-- ========================
-- Manutencao (3+ instâncias)
-- ========================
INSERT INTO manutencao (id, id_lote, id_responsavel, data, descricao, custo) VALUES
(1, 1, 1, '2025-09-10', 'Limpeza de ervas daninhas', 150.00),
(2, 2, 2, '2025-09-12', 'Rega e adubação', 100.00),
(3, 3, 3, '2025-09-15', 'Poda e manutenção de estruturas', 250.00),
(4, 4, 1, '2025-09-18', 'Preparação de solo', 180.00),
(5, 5, 2, '2025-09-20', 'Controle de pragas', 200.00),
(6, 6, 4, '2025-09-22', 'Limpeza geral e reorganização', 220.00);

-- ========================
-- Plantio (N:N Lote-Especie com atributo - 3+ instâncias)
-- ========================
INSERT INTO plantio (id_lote, id_especie, data, quantidade, previsao, status) VALUES
(1, 1, '2025-08-01', 30, '2025-11-01', 'crescendo'),
(1, 3, '2025-08-15', 10, '2025-10-15', 'crescendo'),
(2, 2, '2025-08-05', 50, '2025-09-30', 'pronto-colheita'),
(3, 2, '2025-07-20', 40, '2025-09-15', 'colhido'),
(3, 6, '2025-08-10', 15, '2025-10-10', 'crescendo'),
(4, 5, '2025-09-01', 25, '2025-12-01', 'crescendo'),
(5, 1, '2025-07-15', 35, '2025-10-15', 'perdido'),
(6, 4, '2025-08-20', 20, '2025-11-20', 'crescendo');