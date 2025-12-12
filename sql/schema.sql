-- Schema DDL for "Hortas Urbanas Comunitárias"

-- ========================
-- Core Entities
-- ========================

-- Horta
CREATE TABLE horta (
    id            SERIAL PRIMARY KEY,
    endereco      VARCHAR(255) NOT NULL,
    fundado_em    DATE
);

-- Responsavel (supertype)
CREATE TABLE responsavel (
    id         SERIAL PRIMARY KEY,
    nome       VARCHAR(150) NOT NULL,
    endereco   VARCHAR(255),
    contato    VARCHAR(120)
);

-- Pessoa_fisica (subtype of Responsavel)
-- 1:1 specialization using shared PK that is also FK
CREATE TABLE pessoa_fisica (
    id   INTEGER PRIMARY KEY,
    cpf  VARCHAR(14) NOT NULL UNIQUE,
    CONSTRAINT pessoa_fisica_fk_responsavel
        FOREIGN KEY (id) REFERENCES responsavel(id)
        ON DELETE CASCADE
);

-- Instituicao (subtype of Responsavel)
CREATE TABLE instituicao (
    id                 INTEGER PRIMARY KEY,
    cnpj               VARCHAR(18) NOT NULL UNIQUE,
    nome_representante VARCHAR(150),
    CONSTRAINT instituicao_fk_responsavel
        FOREIGN KEY (id) REFERENCES responsavel(id)
        ON DELETE CASCADE
);

    -- Lote
    CREATE TABLE lote (
        id         SERIAL PRIMARY KEY,
        id_horta   INTEGER NOT NULL,
        area       NUMERIC(10,2) CHECK (area >= 0),
        status     VARCHAR(40) CHECK (
            status IN (
                'ativo',
                'inativo',
                'manutencao'
            )
        ) DEFAULT 'ativo',
        CONSTRAINT lote_fk_horta
            FOREIGN KEY (id_horta) REFERENCES horta(id)
            ON DELETE CASCADE
    );

-- Especie
CREATE TABLE especie (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(120) NOT NULL,
    categoria VARCHAR(50) CHECK (
        categoria IN (
            'Alimenticia',
            'Ornamental',
            'Repelente',
            'PANC','Outros'
            )
        ),
    toxica    BOOLEAN DEFAULT FALSE
);

-- ========================
-- Relationships and Associative Entities
-- ========================

-- Evento (0..N) em Horta, organizado por Responsavel
CREATE TABLE evento (
    id             SERIAL PRIMARY KEY,
    id_responsavel INTEGER,
    id_horta       INTEGER,
    nome           VARCHAR(150) NOT NULL,
    data           DATE NOT NULL,
    CONSTRAINT evento_fk_responsavel
        FOREIGN KEY (id_responsavel) REFERENCES responsavel(id)
        ON DELETE SET NULL,
    CONSTRAINT evento_fk_horta
        FOREIGN KEY (id_horta) REFERENCES horta(id)
        ON DELETE CASCADE
);

-- Lote_Responsavel (N:N) com atributo de período
-- PK: (id_lote, id_responsavel, data_inicio)
CREATE TABLE lote_responsavel (
    id_lote        INTEGER NOT NULL,
    id_responsavel INTEGER NOT NULL,
    data_inicio    DATE NOT NULL,
    data_fim       DATE,
    CONSTRAINT lote_responsavel_pk PRIMARY KEY (id_lote, id_responsavel, data_inicio),
    CONSTRAINT lote_responsavel_fk_lote
        FOREIGN KEY (id_lote) REFERENCES lote(id)
        ON DELETE CASCADE,
    CONSTRAINT lote_responsavel_fk_responsavel
        FOREIGN KEY (id_responsavel) REFERENCES responsavel(id)
        ON DELETE CASCADE,
    CONSTRAINT periodo_valido CHECK (data_fim IS NULL OR data_fim >= data_inicio)
);

-- Manutencao (0..N) em Lote, realizada por Responsavel
CREATE TABLE manutencao (
    id             SERIAL PRIMARY KEY,
    id_lote        INTEGER NOT NULL,
    id_responsavel INTEGER,
    data           DATE NOT NULL,
    descricao      TEXT,
    custo          NUMERIC(12,2) CHECK (custo IS NULL OR custo >= 0),
    CONSTRAINT manutencao_fk_lote
        FOREIGN KEY (id_lote) REFERENCES lote(id)
        ON DELETE CASCADE,
    CONSTRAINT manutencao_fk_responsavel
        FOREIGN KEY (id_responsavel) REFERENCES responsavel(id)
        ON DELETE SET NULL
);

-- Plantio (N:N) Lote-Especie com atributo
-- PK: (id_lote, id_especie, data)
CREATE TABLE plantio (
    id_lote     INTEGER NOT NULL,
    id_especie  INTEGER NOT NULL,
    data        DATE NOT NULL,
    quantidade  INTEGER CHECK (quantidade IS NULL OR quantidade >= 0),
    previsao    DATE,
    status      VARCHAR(40) CHECK (
        status IN (
            'crescendo',
            'pronto-colheita',
            'colhido',
            'perdido'
        )
    ) DEFAULT 'crescendo',
    CONSTRAINT plantio_pk PRIMARY KEY (id_lote, id_especie, data),
    CONSTRAINT plantio_fk_lote
        FOREIGN KEY (id_lote) REFERENCES lote(id)
        ON DELETE CASCADE,
    CONSTRAINT plantio_fk_especie
        FOREIGN KEY (id_especie) REFERENCES especie(id)
        ON DELETE RESTRICT,
    CONSTRAINT previsao_valida CHECK (previsao IS NULL OR previsao >= data)
);

