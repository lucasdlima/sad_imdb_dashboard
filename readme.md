**ETL IMDB com Pentaho & MySQL**

Este repositório automatiza o processo de ETL (Extract, Transform, Load) dos datasets do IMDB (`title.basics.tsv.gz` e `title.ratings.tsv.gz`) usando o **Pentaho Data Integration (PDI)** e carrega o esquema estrela resultante em um **data warehouse MySQL**.

---

## 📂 Estrutura do Repositório

```plaintext
./pentaho/            
  ├── jobs/
  │   └── imdb_etl.kjb    # Job principal que orquestra todo o ETL   
  └── transformations/
      ├── d_titulo.ktr           # Gera dimensão: imdb_dim_titulo
      ├── d_tempo.ktr            # Gera dimensão: imdb_dim_tempo
      ├── d_tipo_titulo.ktr      # Gera dimensão: imdb_dim_tipo_titulo
      ├── d_genero.ktr           # Gera dimensão: imdb_dim_genero
      ├── p_titulo_genero.ktr    # Gera tabela de ponte
      └── fato_avaliacao.ktr     # Gera tabela fato: imdb_fato_avaliacao

./sql/             
  └── imdb_schema.sql    # criação das tabelas

README.md                # Este arquivo
```

---

## 🔎 Fontes de Dados

### `title.basics.tsv.gz`

- **tconst** (string): Identificador único do título
- **titleType** (string): Formato (e.g., movie, short, tvSeries)
- **primaryTitle** (string): Título mais popular
- **originalTitle** (string): Título no idioma original
- **isAdult** (booleano): 0 = não adulto; 1 = adulto
- **startYear** (YYYY): Ano de lançamento (ou início da série de TV)
- **endYear** (YYYY ou `\N`): Ano de término da série; `\N` caso contrário
- **runtimeMinutes** (inteiro): Duração em minutos
- **genres** (lista separada por vírgula): Até três gêneros

### `title.ratings.tsv.gz`

- **tconst** (string): Identificador do título (FK)
- **averageRating** (float): Média ponderada das avaliações dos usuários
- **numVotes** (inteiro): Quantidade de votos recebidos

---

## 🗄️ Esquema Alvo (Star Schema)

### Tabela Fato: `imdb_fato_avaliacao`

| Coluna                     | Descrição                                    |
| -------------------------- | -------------------------------------------- |
| sk\_titulo (FK)            | Chave substituta para `imdb_dim_titulo`      |
| sk\_genero\_principal (FK) | Chave substituta do gênero principal         |
| sk\_tempo\_inicio (FK)     | Chave substituta para `imdb_dim_tempo`       |
| sk\_tipo\_titulo (FK)      | Chave substituta para `imdb_dim_tipo_titulo` |
| duracao\_minutos           | Duração em minutos                           |
| media\_avaliacao           | Avaliação média                              |
| total\_votos               | Número de votos                              |

#### Dimensões

- ``

  - `sk_titulo` (PK)
  - `titulo_principal`
  - `nk_titulo` (chave natural, p.ex. `tconst`)

- ``

  - `sk_tempo` (PK)
  - `ano`, `decada`, `seculo`

- ``

  - `sk_tipo_titulo` (PK)
  - `codigo_tipo`
  - `descricao`

- ``

  - `sk_genero` (PK)
  - `genero`

#### Tabela de Ponte: `imdb_ponte_titulo_genero`

| Coluna            | Descrição                                             |
| ----------------- | ----------------------------------------------------- |
| sk\_titulo (FK)   | Chave para `imdb_dim_titulo`                          |
| sk\_genero (FK)   | Chave para `imdb_dim_genero`                          |
| ordem\_prioridade | Posição do gênero no título (para definir prioridade) |

---

## 🚀 Como Executar

### 1. Pré-requisitos

- **Java 8+**
- **Pentaho Data Integration (PDI)**
- **MySQL Server (8.x recomendável)**
- **MySQL Workbench** ou cliente similar
- **Conexão à internet** para baixar os arquivos IMDB em [https://datasets.imdbws.com/](https://datasets.imdbws.com/)

### 2. Configuração do Repositório

1. Clone este repositório:
   ```bash
   git clone [https://github.com/](https://github.com/)/imdb-etl-pentaho-mysql.git cd imdb-etl-pentaho-mysql
   ```




2. Baixe os arquivos:
- `title.basics.tsv.gz`
- `title.ratings.tsv.gz`

### 3. Inicializar Schema MySQL
1. Crie o banco e as tabelas:
```bash
mysql -u <usuario> -p < mysql-ddl/imdb_schema.sql
````

2. Verifique as tabelas:
   ```sql
   SHOW TABLES IN imdb;
   ```



````

### 4. Configurar Pentaho
1. Abra o Spoon (`spoon.bat`/`spoon.sh`).
2. Configure uma conexão MySQL chamada `IMDB_DW` apontando para o banco `imdb`.
3. Ajuste caminhos de arquivo nas transformações em `pentaho/transformations/`:
- `title_basics_path`
- `title_ratings_path`
4. Opcional: ajuste batch sizes e intervalos de commit nos steps.

### 5. Executar ETL
1. Execute o job principal:
```bash
kitchen.sh -file=jobs/imdb_etl.kjb
````

2. Monitore os logs e valide as tabelas finais.

---

## 🎯 Validação e Uso

- Verifique contagens:
  ```sql
  SELECT COUNT(*) FROM dim\_titulo; SELECT COUNT(*) FROM fato\_avaliacao;
  ```


- Exemplo de consulta:
```sql
SELECT d.titulo_principal, f.media_avaliacao
FROM imdb_fato_avaliacao f
JOIN imdb_dim_titulo d ON f.sk_titulo = d.sk_titulo
ORDER BY f.media_avaliacao DESC
LIMIT 10;
````
