library(dplyr)

allzips <- readRDS("Data.rds")
allzips$LAT <- gsub(",", "", allzips$LAT)
allzips$LAT <- as.numeric(allzips$LAT)  
allzips$LONG <- gsub(",", "", allzips$LONG)
allzips$LONG <- as.numeric(allzips$LONG)

allzips$LAT <- jitter(allzips$LAT)
allzips$LONG <- jitter(allzips$LONG)


#allzips$temporada <- formatC(allzips$temporada, width=5, format="d", flag="0")
#row.names(allzips) <- allzips$zipcode

cleantable <- allzips %>%
  select(
    Temporada = temporada,
    Incendio = nombre_inc,
    Rol = rol,
    Combustible = SUBUSO,
    Region = NOM_REG,
    Provincia = NOM_PROV,
    Comuna = NOM_COM,
    Plan = SOLICITUD,
    Lat = LAT,
    Long = LONG
  )
