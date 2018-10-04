# Required for Accessing API's (HTTP or HTTPS URL's from Web)
library(httr)
# Additional functions to convert json/text to data frame
library(jsonlite)
# Manipulate data
library(dplyr)
# # Using rList package. Since we can see our data is converted into in form of list we use list.select and list.stack to filter columns and create a tibble respectively.
install.packages("rlist")
library(rlist)

library(rvest)

library(xml2)

Konkurs <- read_html("https://w2.brreg.no/kunngjoring/kombisok.jsp?datoFra=01.01.2018&datoTil=01.10.2018&id_region=100&id_fylke=19&id_kommune=1902&id_niva1=51&id_niva2=-+-+-&id_bransje1=0")

konkurs_liste <- Konkurs %>%
  html_nodes("table td") %>%
  html_text()

dframe <- tibble(konkurs_liste)

