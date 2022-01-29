# remotes::install_github("jjesusfilho/trts")

library(trts)
library(jsonlite)


id <- "3692852"

trt_baixar_por_id(2, id = 3892852, instancia = 1, diretorio = ".")

arquivos <- list.files()

json <- fromJSON(arquivos)

polo_ativo <- json$poloAtivo
polo_passivo <- json$poloPassivo

assuntos <- json$assuntos

#---

df <- cjsg %>% 
  select(data_julgamento) %>% 
  mutate(ano = lubridate::year(data_julgamento),
         mes = lubridate::month(data_julgamento, abbr=F, label = T))

count(df, mes, sort = T) %>% View()
