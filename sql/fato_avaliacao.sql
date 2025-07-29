drop table fato_avaliacao;
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

select * from fato_avaliacao;