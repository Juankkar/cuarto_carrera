################################################################################
#########################       INFORME DE PRÁCTICAS           #################
#########################            Microclima                #################
################################################################################

library(tidyverse)
library(DescTools)
library(lubridate)

# Este link provee un script donde tengo una funciones interesantes hechas por mí
source("https://raw.githubusercontent.com/Juankkar/cosas_mias/main/funciones_propias/funR/contraste_hip.R")

microclima <- read_csv("data/microclima.csv") %>% 
  mutate(hora=as.character(hora))

######################
#   Estudio de PAR   #
######################

microclima %>% 
  group_by(hora, estrato) %>% 
  summarise(media=mean(par), sd=sd(par)) %>% 
  ggplot(aes(hora, media, fill=estrato)) +
  geom_bar(stat = "identity", position = "dodge",col="black") +
  geom_errorbar(aes(ymin=media+sd, ymax=media-sd), width = .3, position = position_dodge(.915)) +
  scale_fill_manual(values = c("yellow","red3","skyblue")) +
  geom_hline(yintercept = 0) +
  geom_text(data = tibble(x=c(1,2,3,4),y=c(800,1200,1000,1600)),
            aes(x=x,y=y,label=c(rep("*",4))), inherit.aes = F, size=8) +
  labs(title = "PAR, estudio microclimático del Rosalillo",
       subtitle = "Informe A.F.V, García Estupiñán, J.C., Biología ULL",
       x="Hora",
       y="PAR(micromol·m-2·s-1)",
       fill="Zona") +
  theme_classic() +
  theme(
    axis.line.y = element_line(),
    plot.title = element_text(hjust = .5, face="bold", size = 15),
    plot.subtitle = element_text(hjust = .5, face="bold", size = 11),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14, face="bold"), 
    panel.background = element_blank(),
    legend.position = c(.8,.8),
    legend.background = element_rect(color = "black")
  )

ggsave("results/plots/microclima/12PAR_microclima.png",
       width = 7,
       height = 5)

#----------------------------------------------------#
#  Son las diferencias entre grupos significativas?  #
#----------------------------------------------------#

microc_10_00 <- microclima %>% filter(hora %in% "10:00:00")
th.groups(microc_10_00, par, "par", estrato, "Apical", "Basal", "Media")
pairwise.wilcox.test(x=microc_10_00$par,
                     g=microc_10_00$estrato, 
                     p.adjust.method = "bonf")                # p < 0.05* Para todos los grupos

microc_10_30 <- microclima %>% filter(hora %in% "10:30:00")
th.groups(microc_10_30, par, "par", estrato, "Apical", "Basal", "Media")
pairwise.wilcox.test(x=microc_10_30$par,
                     g=microc_10_30$estrato, 
                     p.adjust.method = "bonf")                # p > 0.05 apical-media y basal-media

microc_11_00 <- microclima %>% filter(hora %in% "11:00:00")
th.groups(microc_11_00, par, "par", estrato, "Apical", "Basal", "Media")
pairwise.wilcox.test(x=microc_11_00$par,
                     g=microc_11_00$estrato, 
                     p.adjust.method = "bonf")                # p > 0.05 apical-media 

microc_11_30 <- microclima %>% filter(hora %in% "11:30:00")
th.groups(microc_11_30, par, "par", estrato, "Apical", "Basal", "Media")
pairwise.wilcox.test(x=microc_11_30$par,
                     g=microc_11_30$estrato, 
                     p.adjust.method = "bonf")                # p > 0.05 apical-media; media-basal 

microc_12_00 <- microclima %>% filter(hora %in% "12:00:00")
th.groups(microc_12_00, par, "par", estrato, "Apical", "Basal", "Media") # p > 0.05
microc_12_30 <- microclima %>% filter(hora %in% "12:30:00")
th.groups(microc_12_30, par, "par", estrato, "Apical", "Basal", "Media") # p > 0.05


######################
# Estudio de Tleaf   #
######################

microclima %>% 
  group_by(hora, estrato) %>% 
  summarise(media=mean(tleaf), sd=sd(tleaf)) %>% 
  ggplot(aes(hora, media, fill=estrato)) +
  geom_bar(stat = "identity", position = "dodge",col="black") +
  geom_errorbar(aes(ymin=media+sd, ymax=media-sd), width = .3, position = position_dodge(.915)) +
  scale_fill_manual(values = c("yellow","red3","skyblue")) +
  geom_hline(yintercept = 0) +
  geom_text(data = tibble(x=2, y=21),
            aes(x=x,y=y,label="*"), inherit.aes = F, size=10) +
  labs(title = "Temperatura, estudio microclimático del Rosalillo",
       subtitle = "Informe A.F.V, García Estupiñán, J.C., Biología ULL",
       x="Hora",
       y="PAR(micromol·m-2·s-1)",
       fill="Zona") +
  theme_classic() +
  theme(
    axis.line.y = element_line(),
    plot.title = element_text(hjust = .5, face="bold", size = 15),
    plot.subtitle = element_text(hjust = .5, face="bold", size = 11),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14, face="bold"), 
    panel.background = element_blank(),
    legend.position = "top",
    legend.background = element_rect(color = "black")
  )

ggsave("results/plots/microclima/13Temp_microclima.png",
       width = 7,
       height = 5)

#----------------------------------------------------#
#  Son las diferencias entre grupos significativas?  #
#----------------------------------------------------#

microc_10_00 <- microclima %>% filter(hora %in% "10:00:00")
tapply(microc_10_00$tleaf,microc_10_00$estrato , shapiro.test)                # No se cumple la normalidad
kruskal.test(tleaf~estrato, data = microc_10_00)                              # p > 0.05


microc_10_30 <- microclima %>% filter(hora %in% "10:30:00")
tapply(microc_10_30$tleaf,microc_10_30$estrato , shapiro.test)                # Se cumple la normalidad
LeveneTest(tleaf~estrato, data = microc_10_30, center=mean)                   # Se cumple homocedasticidad
anova_t10_30 <- aov(tleaf~estrato, data = microc_10_30);summary(anova_t10_30) # p < 0.01 ***
TukeyHSD(anova_t10_30)                                                        # p > 0.05 media-apical; media-basal 

microc_11_00 <- microclima %>% filter(hora %in% "11:00:00")
tapply(microc_11_00$tleaf,microc_11_00$estrato , shapiro.test)                # No se cumple la normalidad
kruskal.test(tleaf~estrato, data = microc_11_00)                              # p > 0.05

microc_11_30 <- microclima %>% filter(hora %in% "11:30:00")
tapply(microc_11_30$tleaf,microc_11_30$estrato , shapiro.test)                # No se cumple la normalidad
kruskal.test(tleaf~estrato, data = microc_11_30)                              # p > 0.05

microc_12_00 <- microclima %>% filter(hora %in% "12:00:00")
tapply(microc_12_00$tleaf,microc_12_00$estrato , shapiro.test)                # No se cumple la normalidad
LeveneTest(tleaf~estrato, data = microc_12_00, center="mean")                 # Se cumple la homocedasticidad
anova_t12_00 <- aov(tleaf~estrato, data = microc_12_00);summary(anova_t12_00) # p > 0.05

microc_12_30 <- microclima %>% filter(hora %in% "12:30:00")
tapply(microc_12_30$tleaf,microc_12_30$estrato , shapiro.test)                # No se cumple la normalidad
kruskal.test(tleaf~estrato, data = microc_12_30)                              # p > 0.05

#------------------------------------------------------------------------------3

th.groups(microc_10_00, tleaf, "tleaf", estrato, "Apical", "Basal", "Media") # p > 0.05
th.groups(microc_10_30, tleaf, "tleaf", estrato, "Apical", "Basal", "Media")
pairwise.wilcox.test(x=microc_10_30$tleaf,
                     g=microc_10_30$estrato, 
                     p.adjust.method = "bonf")                # p > 0.05 apical-media y basal-media
th.groups(microc_11_00, tleaf, "tleaf", estrato, "Apical", "Basal", "Media") # p > 0.05
th.groups(microc_11_30, tleaf, "tleaf", estrato, "Apical", "Basal", "Media") # p > 0.05
th.groups(microc_12_00, tleaf, "tleaf", estrato, "Apical", "Basal", "Media") # p > 0.05
th.groups(microc_12_30, tleaf, "tleaf", estrato, "Apical", "Basal", "Media") # p > 0.05




