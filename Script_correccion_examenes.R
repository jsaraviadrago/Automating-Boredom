wd <- "/home/jsaravia/Descargas/Otros"

setwd(wd)
getwd()

library(irtoys)
library(dplyr)
library(data.table)
library(readxl)
library(stringr)

# (1) Make sure where your files are located
excel_files <- list.files (path = "/home/jsaravia/Descargas/Otros/Examenes", 
                         pattern    = "*.xlsx", 
                         full.names = T)

# (2) Import All excel with 'read_excel()'
library (readxl)
data_real <- as_tibble(rbindlist (lapply (excel_files, read_excel)))


#### Real data ####

# Respuestas de estudiantes
#names(data_real)
#View(data_real)

##### Erase duplicates ####
#data_real <- data_real[!duplicated(data_real$Nombre),]

#### Checking exam answers ####

data_real <- data_real %>%
  mutate_all(tolower)

#### Multiple choice ####

#Sacar la pregunta abierta y el nombre

data_corregido <- data_real %>% 
  select(-Nombre, -P3.2, -P3.3)

# Extraer solo la pregunta abierta
data_pabierta <- data_real %>% 
  select(P3.3)

# Puntuar la pregunta
data_pabierta$puntuacion_abierta <- if_else(data_pabierta$P3.3 == "7" | data_pabierta$P3.3 == "39" 
                                              ,1,0 )
# Extraer solo las puntuaciones
data_pabierta <- data_pabierta %>% 
  select(puntuacion_abierta)

colnames(data_pabierta) <- "P3.3"

data_pabierta[is.na(data_pabierta)] <- 0

# Extraer solo la pregunta con doble respuesta
data_doble_respuesta <- data_real %>% 
  select(P3.2)

# Puntuar la pregunta
data_doble_respuesta$puntuacion_doble <- if_else(data_doble_respuesta$P3.2 == "c" |  data_doble_respuesta$P3.2 == "e",
                                           1,0)
# Extraer solo las puntuaciones
data_doble_respuesta <- data_doble_respuesta %>% 
  select(puntuacion_doble)

colnames(data_doble_respuesta) <- "P3.2"

data_doble_respuesta[is.na(data_doble_respuesta)] <- 0

# C y e son las alternativas correctas. 

# Relacion de claves de respuesta
claves <- list.files(pattern = "claves")

respuestas <- read_excel(claves, sheet = 2)
nombres_preguntas <- respuestas$Pregunta
claves <- respuestas$Respuesta


data_corregido <- data.frame(sco(data_corregido,
                                 claves, na.false = FALSE))

data_corregido[is.na(data_corregido)] <- 0

colnames(data_corregido) <- nombres_preguntas

data_corregido <- data_corregido %>% 
  mutate_at(c("P1", "P2", "P4", "P5", "P7.3", "P8"),
            funs(.*2))

data_corregido$P6 <- if_else(data_corregido$P6 == "1",3,0)



data_corregido <- data.frame(data_corregido, data_doble_respuesta,
                             data_pabierta)

data_corregido$Nota <- apply(data_corregido, 1,sum)

data_final <- data.frame(data_real[,1], data_corregido)

data_final$Nombre <- toupper(data_final$Nombre) # arreglar mayusculas

fwrite(data_final, "Notas_PC1_EST_APLIC.csv")
