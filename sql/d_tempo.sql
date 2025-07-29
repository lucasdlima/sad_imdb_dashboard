USE  imdb;
drop table dim_tempo;
CREATE TABLE dim_tempo (
    sk_tempo INT PRIMARY KEY AUTO_INCREMENT,
    ano INT NOT NULL UNIQUE,
    decada VARCHAR(10) GENERATED ALWAYS AS (CONCAT(FLOOR(ano/10)*10, 's')) STORED,
    seculo VARCHAR(20) GENERATED ALWAYS AS (CONCAT(CEILING(ano/100), 'º século')) STORED
);


select * from dim_tempo;