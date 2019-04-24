setwd("/Users/home/Downloads")
getwd()

rm(list=ls())

list.files()

library(readxl)
library(dplyr)
library(stringr)
library(psych)
library(NLP)
library(tm)
library(tidyr)
library(ggplot2)
library(kableExtra)


data <- read_excel("NEE y problemas de aprendizaje Jul 2018.xlsx")
# table(data$Region)
# names(data)

#head(data.frame(data))


# Ponerle identificador de la Sede#

# data_sede <- group_by(data, Sede) %>% 
#   summarise(Sede_unica = first(Sede))

#(data_sede, "data.sede_base.csv")

data_sede <- read.csv("data.sede.csv")
#names(data_sede)


data <- left_join(data, data_sede[,c(2,4)], by = "Sede")
#names(data)

colnames(data)[c(4,8:14)] <- c("Segundo_nombre",
  "E.autista",
                          "D.visual",
                          "D.Auditiva",
                          "D.Intelectual",
                          "D.Motora",
                          "TDAH",
                          "Otro")
# names(data)
# head(data.frame(data))
# table(data$Sección)
#data  <- data[,c(1,17,3:)]


prueba <- function(x) {
  if_else(is.na(x),0,1)
  }

data_limpia <- apply(data[,c(8:14)], MARGIN = 2, 
      prueba)

data <- cbind(data[,c(1:7,15,17)], data_limpia)

data$Otro <- if_else(is.na(data$Especificar),0,1)

data <- data[,c(1:7,9:16,8)]

#Arreglar sección

data$Sección <- str_to_lower(data$Sección, local = "es") # arreglar mayusculas
data$Sección <- chartr('áéíóú', 'aeiou',data$Sección) # arreglar tildes
data$Sección <- recode(data$Sección, "unica" = "a") # recodificar unica por a
data$Sección <- gsub(pattern = "\\W", replace = "", data$Sección) # arreglar puntuación
#table(data$Sección)
#  Arreglar grado

#table(data$Grado)
data$Grado <- str_to_lower(data$Grado, local = "es") # arreglar mayusculas
data$Grado  <- chartr('áéíóú', 'aeiou',data$Grado) # arreglar tildes
data$Grado  <- chartr('°º.', '          ',data$Grado) # arreglar bolitas


data$Grado <- gsub("grado", "",
                   data$Grado) # arreglar puntuación
data$Grado <- str_trim(data$Grado, side = "both") # arreglar espacios a los lados

data$Grado <- recode(data$Grado, "k" = "0", "ki" = "0",
                     "kinder" = "0", "kinder b" = "0")

data$Grado <- recode(data$Grado, "begginers" = "-2", "beginners" = "-2",
                     "biginners" = "-2", "begeners" = "-2",
                     "begginer" = "-2",
                     "b" = "-2",
                     "pre - kinder" = "-1",
                     "prekinder" = "-1", "pre- kinder" = "-1",
                     "pre kinder" = "-1", "pk" = "-1",
                     "primero" = "1", "segundo" = "2",
                     "tercero" = "3", "cuarto" = "4",
                         "decimo" = "10", "noveno" = "9", 
                         "octavo" = "8", "quinto" = "5",
                         "septimo" = "7", "sexto" = "6",
                         "undecimo" = "11", "decimo primero" = "11")



data$Grado <- recode(data$Grado, "inicial" = "VACIO")
data$Grado <- recode(data$Grado, "5b" = "VACIO")

data$Grado  <- chartr('aeioumrdvtnc', '            ',data$Grado) # arreglar letras
data$Grado <- str_trim(data$Grado, side = "both") # arreglar espacios a los lados

data[c(1,64),6] <- c("-1", "-2")

data$Grado <- factor(data$Grado, levels = c("-2", "-1", "0", "1", "2", "3", "4",
                                            "5", "6", "7", "8", "9", "10", "11", "VACIO"))

#class(data$Grado)
#table(data$Grado)
#View(data)


# Arreglar nombres

data$Nombre  <- chartr('áéíóú', 'aeiou',data$Nombre) # arreglar tildes
data$Segundo_nombre  <- chartr('áéíóú', 'aeiou',data$Segundo_nombre) # arreglar tildes
data$Apellidos  <- chartr('áéíóú', 'aeiou',data$Apellidos) # arreglar tildes

data$Nombre <- str_to_lower(data$Nombre, local = "es") # arreglar mayusculas
data$Segundo_nombre <- str_to_lower(data$Segundo_nombre, local = "es") # arreglar mayusculas
data$Apellidos <- str_to_lower(data$Apellidos, local = "es") # arreglar mayusculas

#Arreglar Especificar
#table(data$Especificar)

data$Especificar  <- chartr('áéíóú', 'aeiou',data$Especificar) # arreglar tildes
data$Especificar <- str_to_lower(data$Especificar, local = "es") # arreglar mayusculas
data$Especificar <- str_trim(data$Especificar, side = "both") # arreglar espacios a los lados
data$Especificar <- gsub(pattern = "\\b[a-z]\\b{1}", replace = " ", data$Especificar) # Quitar articulos
data$Especificar <- gsub(pattern = "\\W", replace = " ", data$Especificar) # arreglar puntuación
#data$Especificar <- gsub(pattern = "\\d", replace = " ", data$Especificar) # Quitar numeros
data$Especificar <- removeWords(data$Especificar, stopwords("spanish")) # Quitar "los"
data$Especificar <- stripWhitespace(data$Especificar)
#############################

# names(data)
# head(data, 20)
#View(data)

a <- rep("dx", 11)
b <- 1:11
c<- paste0(a,b)
#noquote(c)

matriz <- data.frame(matrix(0, dim(data)[1],11))
colnames(matriz) <- noquote(c)
#head(matriz)

#############################

data <- data.frame(data,matriz)
#head(data)

a <- grep("+disl", data$Especificar)
data$dx1[a] <- "Dislalia"

b<- grep("+disg", data$Especificar)
data$dx2[b] <- "Disglosia"

c <- grep("+depresion", data$Especificar)
data$dx3[c] <- "Depresion"

d<- grep("+asperg", data$Especificar)
data$dx4[d] <- "Asperger"

e <- grep("+tdh", data$Especificar)
data$dx5[e] <- "TDH"

f <- grep("+trast", data$Especificar)
data$dx6[f] <- "Trastornos"

g <- grep("+aprend", data$Especificar)
data$dx7[g] <- "Dificultades aprendizaje"


h <- grep("+retar", data$Especificar)
data$dx8[h] <- "Retardo"

i <- grep("+retra", data$Especificar)
data$dx8[i] <- "Retardo"

j <- grep("+transt", data$Especificar)
data$dx6[j] <- "Trastornos"

k <- grep("+conduct", data$Especificar)
data$dx10[k] <- "Conductual"

l <- grep("+leng", data$Especificar)
data$dx11[l] <- "Lenguaje"

# View(data)
# head(data)
#names(data)

data <- data %>%
  unite(dx, dx1, dx2,dx3,dx4,
        dx5,dx6,dx7,dx8,dx9,dx10,
        dx11, sep = ",")

data$dx <- gsub("0", "", 
                data$dx)# arreglar cero a los lados
data$dx <- gsub(",", "", 
                data$dx)# arreglar cero a los lados

data$dx <- str_trim(data$dx, side = "both") # arreglar espacios a los lados
data$dx <- recode(data$dx, "AspergerTrastornos" = "Asperger",
                    "TrastornosConductual" = "Conductual",
                    "TrastornosConductualLenguaje" = "Conductual",
                   "DepresionTrastornos" = "Depresion",
                 "DepresionTrastornosConductual" = "Depresion",
                    "Dificultades aprendizajeConductual" = "Dificultades aprendizaje",
                    "Dificultades aprendizajeConductualLenguaje" = "Dificultades aprendizaje",
                   "Dificultades aprendizajeLenguaje" = "Dificultades aprendizaje",
                    "TrastornosDificultades aprendizaje" = "Dificultades aprendizaje",
                    "TrastornosDificultades aprendizajeLenguaje" ="Dificultades aprendizaje",
                    "Disglosia" ="Disglosia y/o Dislalia",
                    "Dislalia" ="Disglosia y/o Dislalia",
                    "DislaliaDificultades aprendizaje" ="Disglosia y/o Dislalia",
                    "DislaliaDisglosia" ="Disglosia y/o Dislalia",
                    "DislaliaRetardoLenguaje" ="Disglosia y/o Dislalia",
                    "DislaliaTrastornosDificultades aprendizaje" ="Disglosia y/o Dislalia",
                    "Lenguaje" ="Trastorno Lenguaje",
                    "TrastornosLenguaje" ="Trastorno Lenguaje",
                 "ConductualLenguaje" = "Trastorno Lenguaje",
                    "RetardoConductual" ="Retardo",
                    "RetardoLenguaje" ="Retardo Lenguaje",
                    "Trastornos" ="Otros Trastornos")


# table(data$dx)
# dim(data)
# names(data)
######################################################################
######################################################################
######################################################################

#Pegar DNI

data_id <- read_excel("Alumnos 2018.xlsx")
# head(data_id)
# head(data.frame(data_id))

data_id$Nombres  <- chartr('áéíóú', 'aeiou',data_id$Nombres) # arreglar tildes
data_id$Apellidos  <- chartr('áéíóú', 'aeiou',data_id$Apellidos) # arreglar tildes

data_id$Nombres <- str_to_lower(data_id$Nombres, local = "es") # arreglar mayusculas

data_id$Apellidos <- str_to_lower(data_id$Apellidos, local = "es") # arreglar mayusculas

data_id$concatenado <- paste0(data_id$Nombres, data_id$Apellidos)
data_id$concatenado <- gsub(" ", "", data_id$concatenado)# arreglar espacios a los lados

data_prueba <- data_id 
data_prueba$Seccion <- str_to_lower(data_prueba$Seccion, local = "es") # arreglar mayusculas

######################################################################
######################################################################
######################################################################
######################################################################

# head(data)
# names(data_prueba)

data$Segundo_nombre <- if_else(is.na(data$Segundo_nombre),"0",
                               paste0(data$Segundo_nombre))
data$concatenado <- paste0(data$Nombre, data$Segundo_nombre, data$Apellidos)
data$concatenado <- gsub(" ", "", data$concatenado)# arreglar espacios a los lados
data$concatenado <- gsub("0", "", data$concatenado)# arreglar cero a los lados


data_junta <- left_join(data, data_prueba[,c(1,8)], by = "concatenado")


data_junta$DNI <- if_else(is.na(data_junta$DNI),"VACIO", paste0(data_junta$DNI))


data_recuperados <- data_junta %>% 
  filter(DNI != "VACIO")

data_pendientes <- data_junta %>% 
  filter(DNI == "VACIO")

#head(data_pendientes)
#head(data_recuperados)
# dim(data_pendientes)
# View(data_pendientes)
#View(data_prueba)

#head(data.frame(data_prueba))

data_pendientes$DNI <- NULL


separado1 <- data.frame(str_split_fixed(data_prueba$Nombres, " ", 2))

data_prueba <- data.frame(data_prueba, separado1)

data_prueba$concatenado2 <- paste0(data_prueba$X1, data_prueba$Apellidos)

data_prueba$concatenado2 <- gsub(" ", "", data_prueba$concatenado2)# arreglar espacios a los lados



data_pendientes$concatenado2 <- paste0(data_pendientes$Nombre, 
                                   data_pendientes$Apellidos)

data_pendientes$concatenado2 <- gsub(" ", "", 
                                     data_pendientes$concatenado2)# arreglar espacios a los lados



# 
# head(data.frame(data_prueba))
#head(data.frame(data_pendientes))

#names(data_prueba)

data_pendientes <- left_join(data_pendientes, data_prueba[,c(1,11)],
                             by = "concatenado2")

#sum(is.na(data_pendientes$DNI))

##########################

data_pendientes$DNI <- if_else(is.na(data_pendientes$DNI),"VACIO",
                               paste0(data_pendientes$DNI))

data_recuperados2 <- data_pendientes %>% 
  filter(DNI != "VACIO")

data_pendientes2 <- data_pendientes %>% 
  filter(DNI == "VACIO")

##########################
# head(data_pendientes2)
# head(data.frame(data_prueba))
# names(data_prueba)
# #data_prueba
# #data_pendiente2
# View(data_pendientes2)
#head(data_recuperados2)
#dim(data_recuperados)
##########################

data_pendientes2$DNI <- NULL

data_pendientes2$concatenado3 <- paste0(data_pendientes2$Segundo_nombre, 
                                        data_pendientes2$Apellidos)

data_pendientes2$concatenado3 <- gsub(" ", "", 
                                      data_pendientes2$concatenado3)# 

data_pendientes2$concatenado3 <- gsub("0", "", 
                                      data_pendientes2$concatenado3)# 

#names(data_prueba)
#head(data_prueba)
##########################


separado2 <- data.frame(str_split_fixed(data_prueba$Nombres, " ", 3))

data_prueba <- data.frame(data_prueba, separado2)

data_prueba$X2 <- gsub("", "0", 
                                 data_prueba$X2)# 

data_prueba$concatenado3 <- paste0(data_prueba$X2, data_prueba$Apellidos)

data_prueba$concatenado3 <- gsub("0", "", 
                                 data_prueba$concatenado3)# 

data_prueba$concatenado3 <- gsub(" ", "", 
                                 data_prueba$concatenado3)# 

data_prueba <- data_prueba[,c(1:8,11,15)] 
#View(data_prueba)

data_pendientes2 <- left_join(data_pendientes2, data_prueba[,c(1,10)],
                             by = "concatenado3")

#sum(is.na(data_pendientes2$DNI))

##########################

data_pendientes2$DNI <- if_else(is.na(data_pendientes2$DNI),"VACIO",
                               paste0(data_pendientes2$DNI))



data_recuperados3 <- data_pendientes2 %>% 
  filter(DNI != "VACIO")

data_pendientes3 <- data_pendientes2 %>% 
  filter(DNI == "VACIO")

# head(data_recuperados3)
# dim(data_pendientes3)
# dim(data_recuperada)
# View(data_pendientes3)
# head(data_recuperados)
# head(data_recuperados2)
# head(data_recuperados3)
# names(data_recuperados)
# names(data_recuperados2)
# names(data_recuperados3)
##########################


data_recuperados <- data_recuperados[,c(19,1:17)]

data_recuperados2 <- data_recuperados2[,c(20,1:17)]

data_recuperados3 <- data_recuperados3[,c(21,1:17)]

data_recuperada <- rbind(data_recuperados, data_recuperados2, data_recuperados3)

#dim(data_recuperada)
# table(data_recuperada$Region)
# table(data_pendientes3$Region)
#head(data_recuperada)
##############################################################################
##############################################################################

###Notas del Bimestre

#list.files()

data_notas <- read_excel("NotasMateBimestre1.xlsx", sheet = 1) #Notas Mate
#head(data_notas)

colnames(data_notas)[1] <- "DNI"

data_NEE_notas <- left_join(data_recuperada, data_notas[,c(1,7)],
                            by = "DNI")

#head(data_NEE_notas)

addmargins(table(data_NEE_notas$Grado, data_NEE_notas$Calificación))

#View(data_NEE_notas)

##############################################################################
##############################################################################

# Resultados QEL 2017 (mate)

#list.files()

data_qel_mate <- read_excel("CONSOLIDADO_MATE_2017.xlsx", sheet = 1)
# head(data.frame(data_qel_mate))
# class(data_qel_mate$DNI_ALUMNO)
#names(data_qel_mate)

colnames(data_qel_mate)[1] <- "DNI"

data_qel_mate$DNI <- as.character(data_qel_mate$DNI)

data_NEE_QEL <- left_join(data_recuperada, data_qel_mate[,c(1,17:19)], by = "DNI")
#dim(data_NEE_QEL)
##############################################################################
##############################################################################

# Resultados QEL 2017 (Lectura)

#list.files()

data_qel_comu <- read_excel("CONSOLIDADO_COMU_2017.xlsx", sheet = 1)
#names(data_qel_comu)

colnames(data_qel_comu)[1] <- "DNI"

data_qel_comu$DNI <- as.character(data_qel_comu$DNI)
data_NEE_QEL <- left_join(data_NEE_QEL, data_qel_comu[,c(1,17:19)], by = "DNI")

#head(data.frame(data_NEE_QEL))
#names(data_NEE_QEL)

colnames(data_NEE_QEL)[c(21,24)] <- c("Nivel_logro_mate", "Nivel_logro_comu")

##############################################################################
##############################################################################
# Por trabajar

addmargins(table(data_NEE_QEL$Nivel_logro_comu, data_NEE_QEL$Grado))
addmargins(table(data_NEE_QEL$Nivel_logro_mate, data_NEE_QEL$Grado))


################################################################################
################################################################################
################################################################################

qel_dx_comu <- data.frame(addmargins(table(data_NEE_QEL$dx, 
                                             data_NEE_QEL$Nivel_logro_comu)))

qel_dx_comu <- data.frame(qel_dx_comu[1:12,1], Inicio_comunicacion = qel_dx_comu[1:12,3],
                          Proceso_comunicacion = qel_dx_comu[25:36,3],
                          Logrado_comunicacion = qel_dx_comu[13:24,3])

colnames(qel_dx_comu)[1] <- c("DX")



qel_dx_mate <- data.frame(addmargins(table(data_NEE_QEL$dx, 
                                             data_NEE_QEL$Nivel_logro_mate)))

qel_dx_mate <- data.frame(qel_dx_mate[1:12,1], Inicio_matematica = qel_dx_mate[1:12,3],
                          Proceso_matematica = qel_dx_mate[25:36,3],
                          Logrado_matematica = qel_dx_mate[13:24,3])

colnames(qel_dx_mate)[1] <- "DX"

qel_dx_mate_comu <- inner_join(qel_dx_comu, qel_dx_mate, by = "DX")

qel_dx_mate_comu <- qel_dx_mate_comu[c(2:12),] 

qel_dx_mate_comu$DX <- recode(qel_dx_mate_comu$DX, "Sum" = "Total")

colnames(qel_dx_mate_comu)[2:7] <- c("Inicio comunicacion", "Proceso comunicacion",
                                     "Logrado comunicacion", "Inicio matematica",
                                     "Proceso matematica", "Logrado matematica")

rownames(qel_dx_mate_comu) <- qel_dx_mate_comu$DX
qel_dx_mate_comu$DX <- NULL

#write.csv(qel_dx_mate_comu, "qel_dx_mate_comu.csv")

kable(qel_dx_mate_comu) %>% 
  kable_styling(bootstrap_options = "striped", full_width = F)


################################################################################
################################################################################
################################################################################

autismo_qel_comu <- data.frame(addmargins(table(data_NEE_QEL$E.autista,
                            data_NEE_QEL$Nivel_logro_comu)))

autismo_qel_comu <- data.frame(autismo_qel_comu[1:3,1],
                                Inicio_comunicacion =  autismo_qel_comu[1:3,3],
                                Proceso_comunicacion =  autismo_qel_comu[7:9,3],
                                Logrado_comunicacion =  autismo_qel_comu[4:6,3])

colnames(autismo_qel_comu)[1] <- "DX"
autismo_qel_comu$DX <- recode(autismo_qel_comu$DX,
                             "1" = "Autismo")

visual_qel_comu <- data.frame(addmargins(table(data_NEE_QEL$D.visual,
                                          data_NEE_QEL$Nivel_logro_comu)))

visual_qel_comu <- data.frame(visual_qel_comu[1:3,1],
                                Inicio_comunicacion =  visual_qel_comu[1:3,3],
                                Proceso_comunicacion =  visual_qel_comu[7:9,3],
                                Logrado_comunicacion =  visual_qel_comu[4:6,3])

colnames(visual_qel_comu)[1] <- "DX"
visual_qel_comu$DX <- recode(visual_qel_comu$DX,
                               "1" = "Visual")

auditiva_qel_comu <- data.frame(addmargins(table(data_NEE_QEL$D.Auditiva,
                 data_NEE_QEL$Nivel_logro_comu)))

auditiva_qel_comu <- data.frame(auditiva_qel_comu[1:3,1],
                              Inicio_comunicacion =  auditiva_qel_comu[1:3,3],
                              Proceso_comunicacion =  auditiva_qel_comu[7:9,3],
                              Logrado_comunicacion =  auditiva_qel_comu[4:6,3])

colnames(auditiva_qel_comu)[1] <- "DX"
auditiva_qel_comu$DX <- recode(auditiva_qel_comu$DX,
                                  "1" = "Auditiva")
                 
Intelectual_qel_comu <- data.frame(addmargins(table(data_NEE_QEL$D.Intelectual,
                                               data_NEE_QEL$Nivel_logro_comu)))

Intelectual_qel_comu <- data.frame(Intelectual_qel_comu[1:3,1],
                                Inicio_comunicacion =  Intelectual_qel_comu[1:3,3],
                                Proceso_comunicacion =  Intelectual_qel_comu[7:9,3],
                                Logrado_comunicacion =  Intelectual_qel_comu[4:6,3])

colnames(Intelectual_qel_comu)[1] <- "DX"
Intelectual_qel_comu$DX <- recode(Intelectual_qel_comu$DX,
                                  "1" = "Intelectual")


Motora_qel_comu <- data.frame(addmargins(table(data_NEE_QEL$D.Motora,
      data_NEE_QEL$Nivel_logro_comu)))

Motora_qel_comu <- data.frame(Motora_qel_comu[1:3,1],
                                   Inicio_comunicacion =  Motora_qel_comu[1:3,3],
                                   Proceso_comunicacion =  Motora_qel_comu[7:9,3],
                                   Logrado_comunicacion =  Motora_qel_comu[4:6,3])

colnames(Motora_qel_comu)[1] <- "DX"

Motora_qel_comu$DX <- recode(Motora_qel_comu$DX,
                             "1" = "Motora")

tdah_qel_comu <- data.frame(addmargins(table(data_NEE_QEL$TDAH, 
                            data_NEE_QEL$Nivel_logro_comu)))

tdah_qel_comu <- data.frame(tdah_qel_comu[1:3,1],
                              Inicio_comunicacion =  tdah_qel_comu[1:3,3],
                              Proceso_comunicacion =  tdah_qel_comu[7:9,3],
                              Logrado_comunicacion =  tdah_qel_comu[4:6,3])


colnames(tdah_qel_comu)[1] <- "DX"
tdah_qel_comu$DX <- recode(tdah_qel_comu$DX, "1" = "TDH")

data_QEL_disc_comu <- rbind(autismo_qel_comu,visual_qel_comu,auditiva_qel_comu,
                            Intelectual_qel_comu,Motora_qel_comu,tdah_qel_comu)

data_QEL_disc_comu <- data_QEL_disc_comu %>% 
  filter(DX !="0")

data_QEL_disc_comu <- data_QEL_disc_comu %>% 
  filter(DX !="Sum")

rownames(data_QEL_disc_comu) <- data_QEL_disc_comu$DX
data_QEL_disc_comu$DX <- NULL


######################################################################
######################################################################
#####################################################################


autismo_qel_mate <- data.frame(addmargins(table(data_NEE_QEL$E.autista,
                                                data_NEE_QEL$Nivel_logro_mate)))

autismo_qel_mate <- data.frame(autismo_qel_mate[1:3,1],
                               Inicio_matematica =  autismo_qel_mate[1:3,3],
                               Proceso_matematica =  autismo_qel_mate[7:9,3],
                               Logrado_matematica =  autismo_qel_mate[4:6,3])

colnames(autismo_qel_mate)[1] <- "DX"
autismo_qel_mate$DX <- recode(autismo_qel_mate$DX,
                              "1" = "Autismo")

visual_qel_mate <- data.frame(addmargins(table(data_NEE_QEL$D.visual,
                                               data_NEE_QEL$Nivel_logro_mate)))

visual_qel_mate <- data.frame(visual_qel_mate[1:3,1],
                              Inicio_matematica =  visual_qel_mate[1:3,3],
                              Proceso_matematica =  visual_qel_mate[7:9,3],
                              Logrado_matematica =  visual_qel_mate[4:6,3])

colnames(visual_qel_mate)[1] <- "DX"
visual_qel_mate$DX <- recode(visual_qel_mate$DX,
                             "1" = "Visual")

auditiva_qel_mate <- data.frame(addmargins(table(data_NEE_QEL$D.Auditiva,
                                                 data_NEE_QEL$Nivel_logro_mate)))

auditiva_qel_mate <- data.frame(auditiva_qel_mate[1:3,1],
                                Inicio_matematica =  auditiva_qel_mate[1:3,3],
                                Proceso_matematica =  auditiva_qel_mate[7:9,3],
                                Logrado_matematica =  auditiva_qel_mate[4:6,3])

colnames(auditiva_qel_mate)[1] <- "DX"
auditiva_qel_mate$DX <- recode(auditiva_qel_mate$DX,
                               "1" = "Auditiva")

Intelectual_qel_mate <- data.frame(addmargins(table(data_NEE_QEL$D.Intelectual,
                                                    data_NEE_QEL$Nivel_logro_mate)))

Intelectual_qel_mate <- data.frame(Intelectual_qel_mate[1:3,1],
                                   Inicio_matematica =  Intelectual_qel_mate[1:3,3],
                                   Proceso_matematica =  Intelectual_qel_mate[7:9,3],
                                   Logrado_matematica =  Intelectual_qel_mate[4:6,3])

colnames(Intelectual_qel_mate)[1] <- "DX"
Intelectual_qel_mate$DX <- recode(Intelectual_qel_mate$DX,
                                  "1" = "Intelectual")


Motora_qel_mate <- data.frame(addmargins(table(data_NEE_QEL$D.Motora,
                                               data_NEE_QEL$Nivel_logro_mate)))

Motora_qel_mate <- data.frame(Motora_qel_mate[1:3,1],
                              Inicio_matematica =  Motora_qel_mate[1:3,3],
                              Proceso_matematica =  Motora_qel_mate[7:9,3],
                              Logrado_matematica =  Motora_qel_mate[4:6,3])

colnames(Motora_qel_mate)[1] <- "DX"

Motora_qel_mate$DX <- recode(Motora_qel_mate$DX,
                             "1" = "Motora")

tdah_qel_mate <- data.frame(addmargins(table(data_NEE_QEL$TDAH, 
                                             data_NEE_QEL$Nivel_logro_mate)))

tdah_qel_mate <- data.frame(tdah_qel_mate[1:3,1],
                            Inicio_matematica =  tdah_qel_mate[1:3,3],
                            Proceso_matematica =  tdah_qel_mate[7:9,3],
                            Logrado_matematica =  tdah_qel_mate[4:6,3])


colnames(tdah_qel_mate)[1] <- "DX"
tdah_qel_mate$DX <- recode(tdah_qel_mate$DX, "1" = "TDH")

data_QEL_disc_mate <- rbind(autismo_qel_mate,visual_qel_mate,auditiva_qel_mate,
                       Intelectual_qel_mate,Motora_qel_mate,tdah_qel_mate)

data_QEL_disc_mate <- data_QEL_disc_mate %>% 
  filter(DX !="0")

data_QEL_disc_mate <- data_QEL_disc_mate %>% 
  filter(DX !="Sum")

rownames(data_QEL_disc_mate) <- data_QEL_disc_mate$DX
data_QEL_disc_mate$DX <- NULL

################################################################################
################################################################################
################################################################################

data_QEL_disc_mate_comu <- cbind(data_QEL_disc_comu, 
                                      data_QEL_disc_mate)

colnames(data_QEL_disc_mate_comu)[1:6] <- c("Inicio comunicacion", "Proceso comunicacion",
                                     "Logrado comunicacion", "Inicio matematica",
                                     "Proceso matematica", "Logrado matematica")

#write.csv(data_QEL_disc_mate_comu, "data_QEL_disc_mate_comu.csv")

kable(data_QEL_disc_mate_comu) %>% 
  kable_styling(bootstrap_options = "striped", full_width = F)


################################################################################
################################################################################
################################################################################

aut_grado <- data.frame(t(addmargins(table(data$E.autista,
                                data$Grado))))

visual_grado <- data.frame(t(addmargins(table(data$D.visual, data$Grado))))
auditiva_grado <- data.frame(t(addmargins(table(data$D.Auditiva,
                                                data$Grado))))
inte_grado <- data.frame(t(addmargins(table(data$D.Intelectual,
                                            data$Grado))))
motora_grado <- data.frame(t(addmargins(table(data$D.Motora,
                                              data$Grado))))
tdah_grado <- data.frame(t(addmargins(table(data$TDAH,
                                            data$Grado))))

nee <- cbind(aut_grado[,c(1,2,3)],visual_grado[,3],auditiva_grado[,3],inte_grado[,3],
             motora_grado[,3],tdah_grado[,3])
names(nee)
colnames(nee)[1:8] <- c("Grado", "grupo", "Cantidad E.Autista",
                        "Cantidad D.Visual", "Cantidad D.Auditiva",
                        "Cantidad D.Intectual", "Catndiad D.Motora",
                        "Cantidad TDAH")
nee <- nee %>% 
  filter(grupo == 1) 
nee$grupo <- NULL

nee <- nee[c(1:14,16),]
nee$Grado <- recode(nee$Grado, "-2" = "Beginners", "-1" = "Pre-Kinder",
                    "0" = "Kinder", "1" = "Primero", "2" = "Segundo",
                    "3" = "Tercero", "4" = "Cuarto", "5" = "Quinto",
                    "6" = "Sexto", "7" = "Septimo", "8" = "Octavo",
                    "9" = "Noveno", "10" = "Decimo", "11" = "Undecimo", "Sum" = "Total")


rownames(nee) <- nee$Grado
nee$Grado <- NULL

#write.csv(nee, "nee.csv")
##############################################################################
##############################################################################
#Graficos para reporte


kable(nee) %>% 
  kable_styling(bootstrap_options = "striped", full_width = F)





  


