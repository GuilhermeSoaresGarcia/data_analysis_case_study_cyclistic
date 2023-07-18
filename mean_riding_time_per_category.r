library(tidyverse)
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

# Calcular tempo médio de uso dos membros vs. usuários casuais
bikes_mean_riding_time_data <- bikes_csv_files %>% 
  mutate(riding_time=difftime(ended_at, started_at, units = "mins")) %>% 
  group_by(member_casual) %>% 
  summarise(mean_riding_time = round(mean(riding_time), digits = 1))

# Geração do gráfico do tempo médio de uso por categoria
ggplot(data = bikes_mean_riding_time_data,
       mapping = aes(
         x = mean_riding_time,
         y = member_casual,
         fill = member_casual
       )) + 
  geom_col() +
  labs(
    title = "Tempo médio de uso por categoria de usuário",
    subtitle = paste("Baseado em", total_registries, "registros coletados entre", oldest_registry, "e", newest_registry),
    x = "Tempo médio de uso (em minutos)",
    y = "Categoria de usuário"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5), 
    plot.subtitle = element_text(hjust = 0.5)
    ) +
  geom_text(aes(label = mean_riding_time, vjust = 0.5, hjust = 1.9)) +
  guides(fill = "none")
