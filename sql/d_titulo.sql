drop table dim_titulo;
CREATE TABLE dim_titulo (
    sk_titulo INT PRIMARY KEY AUTO_INCREMENT,
    nk_titulo VARCHAR(20) NOT NULL UNIQUE,  -- tconst
    titulo_principal VARCHAR(500)
);


select * from dim_titulo;