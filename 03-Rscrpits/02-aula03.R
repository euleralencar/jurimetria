# remotes::install_github("jjesusfilho/trts")

library(trts)
library(jsonlite)
library(tidyverse)

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
