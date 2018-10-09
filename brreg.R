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

library(stringr)

Konkurs_url <- ("https://w2.brreg.no/kunngjoring/kombisok.jsp?datoFra=01.01.2018&datoTil=01.10.2018&id_region=100&id_fylke=19&id_kommune=-+-+-&id_niva1=51&id_niva2=-+-+-&id_bransje1=0")

konkurs <- read_html(Konkurs_url)

#Bruk selector gadget og hent html_nodes for de alle 4 kollonnene,
#og sett de sammen som vectorer, deretter legg alle sammen som en dataframe og til sluttt få en tabbel.

#Første vektor er hvilken kunngjoringstype det er snakk om

type <- html_nodes(konkurs, 'p a')
Kunngjoring <- type %>%
  html_text(type) %>%
   as.factor()
head(Kunngjoring)

# Deretter en vektor for datoene

Dato <- html_nodes(konkurs, "tr~ tr+ tr td:nth-child(6) p")
Dato <- Dato %>%
  html_text(Dato) %>%
   as.Date(Dato, format = "%d.%m.%Y")

#Så henter vi ut organisasjonsnummer, og fjerner mellomrom mellom nummerene for ryddighets skyld.

Organisasjonsnummer <- html_nodes(konkurs, "td:nth-child(4) p") 
Organisasjonsnummer <- Organisasjonsnummer %>%
  html_text(Organisasjonsnummer) 

Organisasjonsnummer
Organisasjonsnummer <- str_replace_all(string=Organisasjonsnummer, pattern=" ", repl="")

#Deretter vektor for firmanavnene

Firmanavn <- html_nodes(konkurs, "td td:nth-child(2) p")
glimpse(Firmanavn)
#Ser at vi får med Troms som første verdi i navn vektorern og fjerner denne.
Firmanavn <- html_text(Firmanavn[2:264]) 
Firmanavn <- as.character(Firmanavn)

Tabell <- data.frame(Firmanavn, Organisasjonsnummer, Dato, Kunngjoring, stringsAsFactors = FALSE)

#Fjerner privatpersoner fra tabellen

Tabell <- filter(Tabell, Organisasjonsnummer > 6)




