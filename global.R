library(dplyr)

df <- readRDS("Data.rds")

df$LAT <- gsub(",", "", df$LAT)
df$LAT <- as.numeric(df$LAT)  
df$LONG <- gsub(",", "", df$LONG)
df$LONG <- as.numeric(df$LONG)

df$Latitud <- jitter(df$LAT)
df$Longitud <- jitter(df$LONG)
