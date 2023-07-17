# install.packages("tidyverse")
# install.packages("ggplot2")
# install.packages("geosphere")

library(tidyverse)
library(geosphere)
library(ggplot2)

# Definição do Workdir (onde estão os csvs analisados)
setwd("~/Git/data_analysis_case_study_cyclistic/csv/")

# Carregamento dos csvs
bikes_csv_files <-
  list.files(path = ".", pattern = "*.csv", recursive = FALSE) %>% 
  map_df(~read_csv(.)) %>% 
  drop_na()

# Informações sobre os registros (utilizadas no subtítulo do gráfico)
total_registries <- count(bikes_csv_files)
newest_registry <- format(as.Date(max(bikes_csv_files$started_at), format="%Y/%m/%d"), "%d/%m/%Y")
oldest_registry <- format(as.Date(min(bikes_csv_files$started_at), format="%Y/%m/%d"), "%d/%m/%Y")

# Calcular distância média, em Km, percorrida por membros vs. usuários casuais
bikes_mean_distance_data <- bikes_csv_files %>%
  mutate(distance = round(distHaversine(cbind(start_lng, start_lat), cbind(end_lng, end_lat)) / 1000, digits = 1)) %>% 
  group_by(member_casual) %>%
  summarise(mean_distance = round(mean(distance), digits = 1))
View(bikes_mean_distance_data)

# Geração do gráfico da distância média percorrida por categoria
ggplot(data = bikes_mean_distance_data,
       mapping = aes(
         x = mean_distance,
         y = member_casual,
         fill = member_casual
       )) +
  geom_col() +
  labs(
    title = "Distância média percorrida por categoria de usuário",
    subtitle = paste("Baseado em", total_registries, "registros coletados entre", oldest_registry, "e", newest_registry),
    x = "Distância média percorrida (em Km)",
    y = "Categoria de usuário"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  ) +
  guides(fill = "none")
