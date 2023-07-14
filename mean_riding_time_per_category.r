library(ggplot2)
library(tidyverse)

# Definição do Workdir (onde estão os csvs analisados)
setwd("~/Git/data_analysis_case_study_cyclistic/csv/")

# Carregamento dos csvs
bikes_csv_files <-
  list.files(path = ".", pattern = "*.csv", recursive = FALSE) %>% 
  map_df(~read_csv(.)) %>% 
  drop_na()

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
       )) + ggtitle("Tempo médio de uso por categoria de usuário") +
         theme(plot.title = element_text(hjust = 0.3)) +
  geom_col() +
  labs(
    x = "Tempo médio de uso (em minutos)",
    y = "Categoria de usuário"
  ) +
  guides(fill = "none")
  
