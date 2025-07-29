-- Banco de dados a ser utilizado 
USE imdb;

CREATE TABLE dim_tempo (
    sk_tempo INT PRIMARY KEY AUTO_INCREMENT,
    ano INT NOT NULL UNIQUE,
    decada VARCHAR(10) GENERATED ALWAYS AS (CONCAT(FLOOR(ano/10)*10, 's')) STORED,
    seculo VARCHAR(20) GENERATED ALWAYS AS (CONCAT(CEILING(ano/100), 'º século')) STORED
);

CREATE TABLE dim_tipo_titulo (
    sk_tipo_titulo INT PRIMARY KEY AUTO_INCREMENT,
    codigo_tipo VARCHAR(20) NOT NULL UNIQUE,
    descricao VARCHAR(100)
);

CREATE TABLE dim_genero (
    sk_genero INT PRIMARY KEY AUTO_INCREMENT,
    genero VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dim_titulo (
    sk_titulo INT PRIMARY KEY AUTO_INCREMENT,
    nk_titulo VARCHAR(20) NOT NULL UNIQUE,  -- tconst
    titulo_principal VARCHAR(500)
);

CREATE TABLE ponte_titulo_genero (
    sk_titulo INT NOT NULL,
    sk_genero INT NOT NULL,
    ordem_prioridade TINYINT NOT NULL,
    PRIMARY KEY (sk_titulo, sk_genero),
    FOREIGN KEY (sk_titulo) REFERENCES dim_titulo(sk_titulo),
    FOREIGN KEY (sk_genero) REFERENCES dim_genero(sk_genero)
);

CREATE TABLE fato_avaliacao (
    sk_titulo INT NOT NULL,
    sk_tempo_inicio INT,
    sk_tipo_titulo INT NOT NULL,
    sk_genero_principal INT,
    media_avaliacao DECIMAL(3,1) NOT NULL,
    total_votos INT NOT NULL,
    duracao_minutos INT,
    PRIMARY KEY (sk_titulo),
    FOREIGN KEY (sk_titulo) REFERENCES dim_titulo(sk_titulo),
    FOREIGN KEY (sk_tempo_inicio) REFERENCES dim_tempo(sk_tempo),
    FOREIGN KEY (sk_tipo_titulo) REFERENCES dim_tipo_titulo(sk_tipo_titulo),
    FOREIGN KEY (sk_genero_principal) REFERENCES dim_genero(sk_genero)
);
