library("quantmod")
library("tidyverse")
library("readxl")
library("igraph")

#Importamos tickets correspondientes a cada empresa
tickets <- read.csv("C:/Users/abyss/Downloads/Tickers2000.xlsx - Hoja1.csv")
datos_vec <- as.vector(datos$tickers)

#Elegimos unicamente 100 empresas para el analisis
datos_vec2 <- datos_vec[1:100]


#Descartamos tickets que tienen datos privados y/o faltantes
eliminar <- c("SBNY","US15677J1088.SG","CTLT","SIVBQ","SIVPQ","ANSS")
datos_correc <- datos_vec2[!datos_vec2 %in% eliminar]

#Se importan los datos de Yahoo Finance; precios de cierre de acciones por empresa
getSymbols(datos_correc, src = "yahoo", from = "2020-01-01", to = "2024-01-01",
           periodicity = "daily") 

empresas <- list()

for (symbol in datos_correc) { 
  
  getSymbols(symbol,
             src = "yahoo",
             from = "2020-01-01",
             to = "2024-01-01",
             periodicity = "daily")
  
  empresas[[symbol]] <- Cl(get(symbol))
}

#Se organizan los datos en una tabla ordenada
close <- do.call(cbind, empresas)
colnames(close) <- datos_correc

sp500 <- data.frame(close)

#Limpieza de datos, respecto a datos faltantes 
na_por_empresa <- colSums(is.na(sp500))
sort(na_por_empresa, decreasing = TRUE)

#Se seleccionan las empresas que solo tienen menos de 100 datos faltantes
sp500_limpio <- sp500[, na_por_empresa < 100]
sp500_limpio <- na.omit(sp500_limpio)
sapply(sp500_limpio, class)

#Se calculan retornos logaritmicos para resolver un poco la no estacionareidad
retornos <- diff(as.matrix(log(sp500_limpio)))
retornos <- as.data.frame(retornos)

#Se calculan las correlaciones entre datos
correlacion <- cor(retornos, use = "pairwise.complete.obs")

write.csv(correlacion,
          "matriz_correlacion.csv")

png("histograma_correlaciones.png",
    width = 1200,
    height = 900,
    res = 200)

hist(
  correlacion[upper.tri(correlacion)],
  breaks = 50,
  main = "Distribución de correlaciones",
  xlab = "Correlación"
)

#Se aplican diferentes correlaciones para jugar con el filtrado de datos 
adj <- correlacion

adj[abs(adj) < 0.4] <- 0
diag(adj) <- 0

#Matriz de adyacencia para obtener el grafo correspondiente
g <- graph_from_adjacency_matrix(
  adj,
  mode = "undirected",
  weighted = TRUE,
  diag = FALSE
)

write.csv(adj,
          "matriz_adyacencia_04.csv") 

plot(
  comunidades,
  g,
  vertex.size = 5,
  vertex.label = NA
)

com_df <- data.frame(
  empresa = V(g)$name,
  comunidad = membership(comunidades)
)

write.csv(com_df,
          "comunidades.csv",
          row.names = FALSE)

# Guardar imagen
png("grafo_umbral_07.png",
    width = 1600,
    height = 1200,
    res = 200)
