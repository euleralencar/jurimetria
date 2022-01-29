# remotes::install_github("jjesusfilho/trts")

library(trts)
library(jsonlite)
library(tidyverse)
require(tjsp)

# Trabalhando com TRTS   *********************************

id <- "3692852"

trt_baixar_por_id(2, id = 3892852, instancia = 1, diretorio = "01-data-raw/trt_baixados/")

arquivos <- list.files("01-data-raw/trt_baixados/", full.names = T)

json <- fromJSON(arquivos)

polo_ativo <- json$poloAtivo
polo_passivo <- json$poloPassivo

assuntos <- json$assuntos

#---

require(tjsp)

# lista os caminhos do arquivo
arquivos <- list.files("01-data-raw/cjsg", full.names = T)

# leitura das decisões e tabela os dados
cjsg <- tjsp_ler_cjsg(arquivos)

df <- cjsg %>% 
  select(data_julgamento) %>% 
  mutate(ano = lubridate::year(data_julgamento),
         mes = lubridate::month(data_julgamento, abbr=F, label = T),
         dia_semana = lubridate::wday(data_julgamento),
         ano_proceso = str_sub())

# baixar movimentacao
count(df, mes, sort = T) %>% View()


# Trabalha com tabela de movimentação
movimentacao <- ler_movimentacao_cjsg(arquivos)

movimentacao %>% 
  group_by(processo) %>% 
  arrange(desc(data)) %>% 
  slice_tail(n=1)

# Trabalhando com Tidyverse  *********************************

# Vamos trabalhar com a base de cposg

# lista o arquivo agora com cposg
arquivos <- list.files("01-data-raw/cposg", full.names = T)
# transforma numa tabela
cposg <- ler_dados_cposg(arquivos)
# baixar partes
partes <- tjsp_ler_partes(arquivos)
# baixar movimentacao
movimentacao <- ler_movimentacao_cposg(arquivos)
# dispositivo -> decisao
dispositivo <- tjsp_ler_dispositivo(arquivos)
# classifica a decisão, conforme texto do dispositivo
dispositivo$decisao <- tjsp_classificar_writ(dispositivo$dispositivo)

# Vamos verificar a quantidade de movimentações por processo
movimentacao %>% 
  count(processo) %>% 
  arrange(desc(n))

# Podemos usar o group_by para fazer a mesma operação
movimentacao %>% 
  group_by(processo) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))

# Vamos criar uma nova variável com ano da movimentação do processo
movimentacao %>% 
  mutate(ano_movimento = lubridate::year(data))

# Vamos trabalhar com a base cjsg  *********************************
# lista os caminhos do arquivo
arquivos <- list.files("01-data-raw/cjsg", full.names = T)
# leitura das decisões e tabela os dados
cjsg <- tjsp_ler_cjsg(arquivos)

# Separando o processo por seus identificadores
cjsg <- 
cjsg %>% 
  mutate(sequencial = str_sub(processo, 1, 7), 
         digito = str_sub(processo, 8, 9), 
         ano_processo = str_sub(processo, 10, 13), 
         segmento = str_sub(processo, 14), 
         tribunal = str_sub(processo, 15, 16), 
         distribuidor = str_sub(processo, 17, 20), .after = processo
         )

cjsg %>% 
  count(distribuidor)

# Verificar se o termo covid aparece na ementa
cjsg <-
cjsg %>% 
  mutate(covid = str_detect(ementa, "(?i)covid"))
# '(?i)' -> Ignora o case sensitive

# Tabela para verificação do termo covid
cjsg %>% 
  count(covid)


# Verificar se o termo aparece concedido
cjsg <-
cjsg %>% 
  mutate(concedido = str_detect(ementa, "(?i)conced"))

# Tabela para verificação do termo concedido
cjsg %>% count(concedido)


# Verificar as variáveis que são lógicas
cjsg %>% 
  select(classe, where(is.logical)) 

# Vamos transformar todas as colunas logicas em numéricas
cjsg <-
cjsg %>% 
  # select(classe, where(is.logical)) %>% 
  mutate(across(where(is.logical), as.numeric))
cjsg

# Filter   *********************************
covid <- 
  cjsg %>% 
  filter(covid == 1)

covid %>% 
  group_by(concedido) %>% 
  summarise(n = n())

covid_concedido <- cjsg %>% 
  filter(covid == 1, concedido == 1)
