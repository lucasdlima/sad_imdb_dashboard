drop table ponte_titulo_genero;
CREATE TABLE ponte_titulo_genero (
    sk_titulo INT NOT NULL,
    sk_genero INT NOT NULL,
    ordem_prioridade TINYINT NOT NULL,
    PRIMARY KEY (sk_titulo, sk_genero),
    FOREIGN KEY (sk_titulo) REFERENCES dim_titulo(sk_titulo),
    FOREIGN KEY (sk_genero) REFERENCES dim_genero(sk_genero)
);

select * from ponte_titulo_genero;