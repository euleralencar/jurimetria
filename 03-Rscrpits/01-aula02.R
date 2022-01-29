# require(remotes)
require(tjsp)

# cjsg -> consulta jurisprudencial
# cposg -> consulta dos procesoso


# Leitura da consulta processual ------------------------------------------


# baixar os casos de covid - consulta jurisprudencial
tjsp_baixar_cjsg(
  livre = "covid",
  classe = "307",
  diretorio = "01-data-raw/cjsg",
  # baixa os 10 primeiros
  n = 10
)

# lista os caminhos do arquivo
arquivos <- list.files("01-data-raw/cjsg", full.names = T)

# leitura das decisões e tabela os dados
cjsg <- tjsp_ler_cjsg(arquivos)


# Leitura do processo em si --------------------------------------------


# baixar o cposg - segunda instancai
tjsp_baixar_cposg(cjsg$processo[1:10],
                  diretorio = "01-data-raw/cposg")

# lista o arquivo agora com cposg
arquivos <- list.files("01-data-raw/cposg", full.names = T)

# transforma numa tabela
cposg <- ler_dados_cposg(arquivos)

# somente advogado
# autenticar() #-> esta liberado

# baixar partes
partes <- tjsp_ler_partes(arquivos)

# baixar movimentacao
movimentacao <- ler_movimentacao_cposg(arquivos)

# dispositivo -> decisao
dispositivo <- tjsp_ler_dispositivo(arquivos)

# classifica a decisão, conforme texto do dispositivo
dispositivo$decisao <- tjsp_classificar_writ(dispositivo$dispositivo)
