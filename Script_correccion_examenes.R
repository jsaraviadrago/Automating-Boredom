wd <- "/home/jsaravia/Descargas"

setwd(wd)
getwd()

library(irtoys)
library(dplyr)
library(data.table)

#### Example data frame ####
# 
# # Create a random data.frame
# set.seed(123)
# data_example <- data.frame(replicate(20,
#                                      sample(c("a", "b", "c", "d", "e", NA),
#                                             50,rep=TRUE)))
# 
# # Create an ID variable with random duplicates
# set.seed(456)
# data_example$id <- sample(50, size = nrow(data_example), replace = TRUE)
# 
# # Search for duplicates
# table(table(data_example$id))

############

#### Real data ####

examen <- (list.files(pattern = "Respuestas"))
data_real <- fread(examen)


##### Erase duplicates ####
data_real <- data_real[!duplicated(data_real$id),]

#### Checking exam answers ####

#### Multiple choice ####

row.names(data_corregido) <- data_real$id

data_corregido <- data_real %>% 
  select(-id)

claves <- list.files(pattern = "claves")

claves <- fread(claves)

claves <- claves$Respuesta

data_corregido <- data.frame(sco(data_corregido, claves, na.false = FALSE))

data_corregido[is.na(data_corregido)] <- 0

data_corregido$Total <- apply(data_corregido, 1,sum)


