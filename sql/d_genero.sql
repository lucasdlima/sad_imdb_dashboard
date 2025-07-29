drop table dim_genero;
CREATE TABLE dim_genero (
    sk_genero INT PRIMARY KEY AUTO_INCREMENT,
    genero VARCHAR(100) NOT NULL UNIQUE
);

select * from dim_genero;