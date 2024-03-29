################################################################################
########### PRÁCTICAS DE INFORMÁTICA DE FISIOLOGÍA ANIMAL APLICADA  ############
################################################################################

library(tidyverse)
library(rstatix)
library(glue)
library(ggtext)

# Necesitas información del script de este script. 
source("artemias/code/01inferencia_estadistica.R")

matrix_artemias <- read_csv("artemias/data/matrix_artemias.csv")

tidy_artemias <- matrix_artemias %>% 
  mutate(tratamiento = Tratamiento,
         tratamiento = case_when(tratamiento == 1 ~ "Levadura",
                                 tratamiento == 2 ~ "Lectina marina",
                                 tratamiento == 3 ~ "Echium/Bacalao",
                                 tratamiento == 4 ~ "Enriquecedor comercial")) %>% 
  select(-Tratamiento) %>% 
  pivot_longer(-tratamiento, names_to  = "acido_graso", values_to = "valores")

#------------------------------------------------------------------------------#
#                               Visualización de los datos               
#------------------------------------------------------------------------------#

# Para estudiar los datos y argumentar la normalidad de los datospodemos usar un histograna/gráfico de
# desnidad. 

tidy_artemias %>%
  ggplot(aes(valores, fill=tratamiento)) +
  geom_density() +
  facet_wrap(~acido_graso, scales="free")

ggsave("artemias/results/plots/normalidad.png",
      width=8, 
      height = 5)

# Resultados del ANOVA de una vía

artemias_anova <- tidy_artemias %>% 
  filter(acido_graso %in% c("C 18:2n-6", "C 18:4n-3", "C 20:4n-6")) %>% 
  mutate(tratamiento=factor(tratamiento, 
                            levels = c("Levadura", "Lectina marina", 
                                       "Echium/Bacalao", "Enriquecedor comercial"),
                            labels = c("Levadura", "Lectina\nmarina", 
                                       "Aceite\nEchium/Bacalao", "Enriquecedor\ncomercial")))

artemias_anova %>% 
  group_by(tratamiento, acido_graso) %>% 
  summarise(media = mean(valores), sd=sd(valores)) %>% 
  ggplot(aes(acido_graso, media, fill=tratamiento)) +
  geom_bar(stat = "identity", position = position_dodge(),
           color="black") +
  geom_errorbar(aes(ymin=media-sd, ymax=media+sd), width=.2,
                position = position_dodge(.9)) +
  scale_fill_manual(values = c("skyblue", "orange", "tomato", "gray")) +
  scale_y_continuous(expand = expansion(0),
                     limits = c(0,10)) +
  labs(
    title = "Porcentaje de área de AG en cada tratamiento",
    subtitle = "Datos normales y homocedásticos",
    x=NULL,
    y="% de área de AG",
    fill="Tratamiento"
  ) +
  theme_classic() +
  theme_classic() +
  theme(
    axis.line = element_line(size=1),
    axis.ticks.y = element_line(size=1),
    axis.ticks.x = element_blank(),
    plot.title = element_text(size = 14, face = "bold", hjust = .5),
    plot.subtitle = element_text(size = 12, face = "italic", hjust = .5,
                                 margin = margin(b=30)),
    axis.title = element_text(face = "bold"),
    legend.position = "bottom",
    legend.background = element_rect(color = "white"),
    axis.text.x = element_text(face = "bold", 
                               color = "black", size = 11)
  )


ggsave("artemias/results/plots/area_ag.png",
     width = 7, 
     height = 4)

artemias_welch <- tidy_artemias %>% 
  filter(acido_graso %in% c("C 16:1n-7","C 18:0","C 18:1n-9",
                            "C 18:3n-6","C 20:5n-3","C 22:6n-3")) %>% 
  mutate(tratamiento=factor(tratamiento, 
                            levels = c("Levadura", "Lectina marina", 
                                       "Echium/Bacalao", "Enriquecedor comercial"),
                            labels = c("Levadura", "Lectina\nmarina", 
                                       "Aceite\nEchium/Bacalao", "Enriquecedor\ncomercial")))

artemias_welch %>% 
  group_by(tratamiento, acido_graso) %>% 
  summarise(media = mean(valores), sd=sd(valores)) %>% 
  ggplot(aes(acido_graso, media, fill=tratamiento)) +
  geom_bar(stat = "identity", position = position_dodge(),
           color="black") +
  geom_errorbar(aes(ymin=media-sd, ymax=media+sd), width=.2,
                position = position_dodge(.9)) +
  scale_fill_manual(values = c("skyblue", "orange", "tomato", "gray")) +
  scale_y_continuous(expand = expansion(0),
                     limits = c(0,25)) +
  labs(
    title = "Porcentaje de área de AG en cada tratamiento",
    subtitle = "Datos normales y no homocedásticos",
    x=NULL,
    y="% de área de AG",
    fill="Tratamiento"
  ) +
  theme_classic() +
  theme_classic() +
  theme(
    axis.line = element_line(size=1),
    axis.ticks.y = element_line(size=1),
    axis.ticks.x = element_blank(),
    plot.title = element_text(size = 14, face = "bold", hjust = .5),
    plot.subtitle = element_text(size = 12, face = "italic", hjust = .5,
                                 margin = margin(b=30)),
    axis.title = element_text(face = "bold"),
    legend.position = "bottom",
    legend.background = element_rect(color = "white"),
    axis.text.x = element_text(face = "bold", 
                               color = "black", size = 11)
  )

ggsave("artemias/results/plots/normalidad_homocedasticidad.png",
       width = 7, 
       height = 4)

artemias_kw <- tidy_artemias %>% 
  filter(acido_graso %in% vect_kw) %>% 
  mutate(tratamiento=factor(tratamiento, 
                            levels = c("Levadura", "Lectina marina", 
                                       "Echium/Bacalao", "Enriquecedor comercial"),
                            labels = c("Levadura", "Lectina\nmarina", 
                                       "Aceite\nEchium/Bacalao", "Enriquecedor\ncomercial")))


artemias_kw %>% 
  ggplot(aes(acido_graso, valores, fill=tratamiento)) +
  geom_boxplot() +
  geom_jitter(position = position_jitterdodge(seed = 20101997), pch=21) +
  scale_fill_manual(values = c("skyblue", "orange", "tomato", "gray")) +
  facet_wrap(~acido_graso, scales = "free") +
  labs(
    title = "Porcentaje de área de AG en cada tratamiento",
    subtitle = "Datos no normales",
    x=NULL,
    y="% de área de AG",
    fill="Tratamiento"
  ) +
  theme_classic() +
  theme_classic() +
  theme(
    axis.line = element_line(size=1),
    axis.ticks.y = element_line(size=1),
    axis.ticks.x = element_blank(),
    plot.title = element_text(size = 14, face = "bold", hjust = .5),
    plot.subtitle = element_text(size = 12, face = "italic", hjust = .5,
                                 margin = margin(b=30)),
    axis.title = element_text(face = "bold"),
    legend.position = "bottom",
    legend.background = element_rect(color = "white"),
    axis.text.x = element_text(face = "bold", 
                               color = "black", size = 11),
    strip.background = element_blank(),
    strip.text = element_blank()
  )

 ggsave("artemias/results/plots/no_normles.png",
        width = 8, 
        height = 4)