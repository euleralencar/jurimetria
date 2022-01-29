### Jurimetria Aplicada

## Aula 01

# Slides da Aula:
# https://direito.consudata.com.br/jurimetria/introducao/

# Resumo:
# https://field-fireman-b25.notion.site/Aula-01-1ebccddb8eac4af3b4a38971f8ba2b39

# Instalação dos Pacotes
install.packages("remotes")
install.packages("tidyverse")
install.packages("writexl")
remotes::install_github("jjesusfilho/tjsp")
remotes::install_github("jjesusfilho/stf")
remotes::install_github("jjesusfilho/stj")
remotes::install_github("jjesusfilho/JurisVis")

## Demonstração do R

# Matemática
2+2
2*5
3*8

# Atribuição de valor a um objeto
m <- 3*8
n <- 2*3
24/6
m/n

# Gráfico
hist(rnorm(1000))

# Bibliografia Complementar
# https://www.tidytextmining.com
# https://smltar.com


## Aula 02

# Material sobre Git e Github
# https://mauriciovancine.github.io/workshop/workshop-git-github-rstudio-2021/

# Parte 01: R Markdown

## Configurar o Github no RStudio
install.packages("usethis")
# Configurar nome e e-mail
usethis::use_git_config(user.name = "YourName", user.email = "your@mail.com")
# Criar o Token para autenticação
usethis::create_github_token() 
# Configurar o Token
credentials::set_github_pat("YourPAT")
#### 4. Reinicie o R! 
#### 5. Verificar configuração
usethis::git_sitrep()

###Objetos no R

## interger (inteiros)
1L
inteiro <- 2L
inteiro2 <- 3L
2L+3L
inteiro+inteiro2
typeof(inteiro)
is.integer(inteiro)
is.double (inteiro2)
is.numeric(inteiro)

## Double (números reais - não inteiros)
2.5
3.4
pi
double1 <- 2.5
double2 <- 3.4
typeof(double1)
is.integer(double2)
is.numeric(double2)

## caracter 
nome <- "Carlos"
nome2 <- "Luisa"
numero <- "2"
numero2 <- "3"
numero+numero2

# O R não realiza cálculo quando o objeto está classificado como texto.
# Para calcular, é preciso converter para numérico
as.numeric(numero) + as.numeric(numero2)

## Data (observar a forma de uso da data no R)
data1 <- "2022-01-22"
data1 <- as.Date(data1)
data2 <- as.Date("2022-01-01")
data1 - data2
class(data1)
typeof(data1)
as.numeric(data1)
as.numeric(data2)
data3 <- as.Date("1969-12-20")
as.numeric(data3)

## Factors (Sequência de valores definidos por níveis, ex. variável categórica)
nomes <- c("Ariadne", "David", "Lucas", "Ariadne", "Lucas")
nomes <- as.factor(nomes)
levels(nomes)
as.numeric(nomes)
as.character(nomes)
numeros2 <- c(1,2,3,4,5,6,99, 99, 99, 104, 104, 104, 104, 104,400,5000)
numeros2 <- as.factor(numeros2)
levels(numeros2)
as.numeric(numeros2)
as.numeric(as.character(numeros2))

## Vectors (conjunto de caracteres alfanuméricos)
nomes <- c("Ariadne", "Davi", "Lucas")
numeros1 <- 1:10
numeros2 <- c(1,2,3,4,5,6,99,104,400,5000)
datavetor <- as.Date(c("2022-01-01", "2022-01-22"))

## Dataframes (objetos de 2 dimensões que pode misturar colunas de classes diferentes)
df <- data.frame(
  nome = c("Fux", "Toffoli", "Carmen", "Weber", "Gilmar"),
  decisao = c("provido", "improvido", "extinto", "feliz", "infeliz")
  )
class(df)
typeof(df)
df[1]
df[[1]]

## Matrizes (vetor bidimensional constituído por linhas e colunas com objetos de mesma classe)
matriz <- matrix(numeros1, ncol = 2)

## Listas
lista <- list(nomes, df, matriz, 2, "Gustavo")
lista <- list(nomes=nomes, dataframe=df, m=matriz, numero=2, nonproprio="Gustavo")
lista[3]
lista[1]
lista[[1]]
lista$nomes
lista["nomes"]

## Funções
Sys.time()
sqrt(4)

## Verificar o diretório
getwd()

## criar novos diretórios para salvar os arquivos que serão baixados
dir.create("data")
dir.create("data-raw")
dir.create("data/cjsg")
dir.create("data-raw/cjsg")
dir.create("data-raw/cposg")

# Manual do pacote TJSP
?tjsp

# Script para baixar os dados do TJSP sobre HC em covid:
library(tjsp)

tjsp_baixar_cjsg(
  livre = "covid",
  classe = "307",
  diretorio = "data-raw/cjsg",
  n = 10
)

#Listar arquivos baixados
list.files("data-raw/cjsg", full.names = T)

# Ler o conteúdo baixado
cjsg <- tjsp_ler_cjsg(diretorio = "data-raw/cjsg")

# Ver o conteúdo baixado
View(cjsg)

# Salvar em .csv
write.csv(cjsg, "data/cjsg.csv")

# Salvar em Excel
library(readr)
library(writexl)
write_xlsx(cjsg, "data/cjsg.xlsx")

# Salvar no formato R
saveRDS(cjsg, "data/cjsg.rds")

# Baixar Acórdãos do TJSP (Requer Certificado Digital)

arquivos <- list.files("data-raw/cjsg", full.names = T)

cjsg <- tjsp_ler_cjsg(arquivos)

tjsp_baixar_cposg(cjsg$processo[1:10],diretorio = "data-raw/cposg")

arquivos <- list.files("data-raw/cposg", full.names = T)


cposg <- ler_dados_cposg(arquivos)

autenticar()


cposg <- ler_dados_cposg(arquivos)

partes <- tjsp_ler_partes(arquivos)

movimentacao <- ler_movimentacao_cposg(arquivos)

dispositivo <- tjsp_ler_dispositivo(arquivos)

dispositivo$decisao <- tjsp_classificar_writ(dispositivo$dispositivo)

#FIM