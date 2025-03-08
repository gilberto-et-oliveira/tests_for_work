##### Descrição da rotina
# Processamentos para retirar efeito sal e pimenta de dado no formato matricial.
# Dados utilizados: MapBiomas coleção 9; Área urbanizada do Uso e Cobertura 2023
# Localidade: Jacareí, São Paulo, Brasil


# Carregando pacotes necessários
library(terra)
library(sf)

# Definindo o caminho do arquivo raster
raster_path <- "Downloads/Linkedin/rasters/MAPBIOMAS-EXPORT-20250308T144234Z-001/MAPBIOMAS-EXPORT/JAC_urban_23.tif"
shapefile_output <- "Downloads/Linkedin/rasters/MAPBIOMAS-EXPORT-20250308T144234Z-001/MAPBIOMAS-EXPORT/JAC_urban_23.shp"

# Carregando o raster
data_raster <- rast(raster_path)

# plotar as imagens em 2 linhas e 2 colunas
par(mfrow = c(2, 2) )  
plot(data_raster, main = "Raster Original")

# Aplicando o filtro sieve para remover áreas menores que determinado valor
# Aplicado para 24 pixels ou aproximadamente 21Km²
filtered_raster <- sieve(data_raster, threshold = 24, directions = 4)
plot(filtered_raster, main = "Raster Após Filtragem")

# Substituindo valores para manter apenas a área urbana
filtered_raster <- subst(filtered_raster, 0, NA)
plot(filtered_raster, main = "Raster Com Apenas Áreas Urbanizadas")

# Convertendo raster para vetor
vector_polygons <- as.polygons(filtered_raster)
vector_sf <- st_as_sf(vector_polygons)

# Convertendo de multi-polígonos para polígonos únicos
vector_singlepart <- st_cast(vector_sf, "POLYGON")
plot(vector_singlepart$geometry, main = "Dado Após Filtragem e Vetorização", col = 'yellow')

# Garantindo geometrias válidas
vector_valid <- st_make_valid(vector_singlepart)

# Reprojetando para EPSG 4674
vector_reprojected <- st_transform(vector_valid, crs = 4674)

# Exportando o shapefile
st_write(vector_reprojected, shapefile_output, append = FALSE)


