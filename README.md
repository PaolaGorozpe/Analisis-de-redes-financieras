# Análisis de Redes Financieras

Este proyecto en R esta enfocado en la construcción y análisis de redes financieras apartir de correlaciones entre empresas del S&P 500.

## Herramientas utilizadas
- R
- igraph
- quantmod
- tidyverse

## Objetivo
Detectar comunidades financieras apartir de diferentes umbrales de correlacion e identificar si es posible analizar relaciones entre empresas mediante grafos ponderados.

## Metodologia

1. Descargar los precios de cierre diarios de las acciones apartir de Yahoo Finance en el periodo comprendido entre 1/01/2020 al 1/01/2024.
2. Limpiar los datos faltantes
3. Calcular los rendimientos logarítmicos
4. Construir la matriz de correlación
5. Aplicar umbrales de correlación
6. Construir la matriz de adyacencia
7. Generar la red financiera
8. Detectar comunidades mediante el algoritmo de agrupamiento de Louvain

## Hallazgos
i. Las redes financieras son bastante sensibles a los umbrales de correlación.

ii. Umbrales más bajos generan sistemas más densos y conectados.

iii. Se identifican algunas comunidades localizadas, lo que sugiere que existe un comportamiento sectorial entre las empresas.
