library(dplyr)

df <- readRDS("Data/Data.rds")

df$LAT <- gsub(",", "", df$LAT)
df$LAT <- as.numeric(df$LAT)  
df$LONG <- gsub(",", "", df$LONG)
df$LONG <- as.numeric(df$LONG)

df$Latitud <- jitter(df$LAT)
df$Longitud <- jitter(df$LONG)

df <- df %>%
  select(
    Temporada = temporada,
    Incendio = nombre_inc,
    Rol = rol,
    Combustible = SUBUSO,
    Region = NOM_REG,
    Provincia = NOM_PROV,
    Comuna = NOM_COM,
    Plan = SOLICITUD,
    Latitud = Latitud,
    Longitud = Longitud
  )

