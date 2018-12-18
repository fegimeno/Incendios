library(dplyr)

Datos <- read.csv("Data/Datos.csv")
IDseq <- seq(1:length(Datos[,1]))
Datos <- cbind(Datos,IDseq)
row.names(Datos) <- seq(1:length(Datos[,1]))

cleantable <- Datos %>%
  select(
    IDseq = IDseq,
    Temporada = temporada,
    Incendio = nombre_inc,
    Predio = NOM_PREDIO,
    Rol = ROL_AVAL,
    Uso = USO_TIERRA,
    Subuso = SUBUSO,
    Region = NOM_REG,
    Provincia = NOM_PROV,
    Comuna = NOM_COM,
    Solicitud = SOLICITUD,
    Estado = ESTAD_SOL,
    Ano =ANO,
    LAT = LAT,
    LONG = LONG
  )

cleantable[,1] <- as.vector(cleantable[,1])
cleantable[,2] <- as.vector(cleantable[,2])
cleantable[,3] <- as.vector(cleantable[,3])
cleantable[,4] <- as.vector(cleantable[,4])
cleantable[,5] <- as.vector(cleantable[,5])
cleantable[,6] <- as.vector(cleantable[,6])
cleantable[,7] <- as.vector(cleantable[,7])
cleantable[,8] <- as.vector(cleantable[,8])
cleantable[,9] <- as.vector(cleantable[,9])
cleantable[,10] <- as.vector(cleantable[,10])
cleantable[,11] <- as.vector(cleantable[,11])



