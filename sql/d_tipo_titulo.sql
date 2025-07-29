drop table dim_tipo_titulo;
CREATE TABLE dim_tipo_titulo (
    sk_tipo_titulo INT PRIMARY KEY AUTO_INCREMENT,
    codigo_tipo VARCHAR(20) NOT NULL UNIQUE,
    descricao VARCHAR(100)
);

select * from dim_tipo_titulo;
