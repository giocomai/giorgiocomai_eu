if (!require("pacman")) install.packages("pacman",  repos = "https://cloud.r-project.org") # for taking care of package installation/loading

pacman::p_load("tidyverse")
pacman::p_load("ggalluvial")
pacman::p_load("extrafont")

options(scipen=999)


read_csv("authorAvailablePP.csv") %>% 
  ggplot(mapping = aes(x = Year, y = n, fill = AuthorAvailable, alpha = FullYear)) +
  geom_col(colour = "black") +
  scale_fill_viridis_d(guide = guide_legend(title = NULL)) +
  scale_alpha_continuous(range = c(0.6, 1), guide = "none") +
  scale_y_continuous(name = "Numero degli articoli") +
  scale_x_continuous(name = "", breaks = scales::pretty_breaks(n = 5)) +
  theme_minimal(base_family = "Carlito") +
  labs(title = "La maggior parte delle notizie include il nome dell'autore",
       subtitle = expression(paste("Totale di notizie pubblicate su ", italic("Pervy Pridnestrovski"),  " tra gennaio 2012 e maggio 2018")), 
       caption = "* Per il 2018, i dati inclusono solo pubblicazioni precedenti il 30 maggio 2018")

ggsave(filename = "authorAvailablePP_it.png", width = 20, height = 10, units = "cm")

read_csv("regularContributorsPP.csv") %>% 
  ggplot(mapping = aes(x = Year, y = nn, fill = Regular)) +
  geom_col(colour = "black") +
  scale_fill_viridis_d(guide = guide_legend(title = NULL)) +
  scale_y_continuous(name = "Numero di giornalisti") +
  scale_x_continuous(name = "", breaks = scales::pretty_breaks(n = 5)) +
  theme_minimal(base_family = "Carlito") +
  labs(title = expression(paste("Circa la metà dei giornalisti il cui nome appare su ", italic("Pervy Pridnestrovski"), " è un contributore regolare")),
       subtitle = expression(paste("Numero totale dei giornalisti il cui nome appare su ", italic("Pervy Pridnestrovski"), " tra gennaio 2012 e maggio 2018")))

ggsave(filename = "regularContributorsPP_it.png", width = 20, height = 10, units = "cm")


read_csv("articlesByRegular_PP.csv") %>% 
  ggplot(mapping = aes(x = Year, y = nn, fill = Regular)) +
  geom_col(colour = "black") +
  scale_fill_viridis_d(guide = guide_legend(title = NULL)) +
  scale_y_continuous(name = "Numero di articoli") +
  scale_x_continuous(name = "", breaks = scales::pretty_breaks(n = 5)) +
  theme_minimal(base_family = "Carlito") +
  labs(title = "Un piccolo gruppo di giornalisti produce gran parte dei contenuti",
       subtitle = expression(paste("Numero totale di articoli pubblicati su ", italic("Pervy Pridnestrovski"), " tra gennaio 2012 e maggio 2018")))

ggsave(filename = "articlesByRegular_PP_it.png", width = 20, height = 10, units = "cm")

## Alluvial

read_csv(file = "regularLeavePP.csv") %>% 
  mutate(Working = str_replace_all(string = Working, pattern = "Working", replacement = "Attivo")) %>% 
  mutate(Working = str_replace_all(string = Working, pattern = "Joined", replacement = "Nuovo arrivo")) %>%
  mutate(Working = str_replace_all(string = Working, pattern = "Left", replacement = "Non più attivo")) %>% 
  mutate(Working = factor(x = Working, levels = c("Non più attivo", "Nuovo arrivo", "Attivo"))) %>% 
  ggplot(aes(x = Year, stratum = Working, alluvium = author, fill = Working, label = Working)) +
  scale_fill_viridis_d(option = "D") +
  #scale_fill_brewer(type = "qual", palette = "Set2") +
  geom_flow(stat = "alluvium", lode.guidance = "rightleft",
            color = "darkgray") +
  geom_stratum() +
  scale_x_continuous("") +
  labs(title = expression(paste("Quanti giornalisti regolari arrivano a ", italic("Pervy Pridnestrovski"), " e quanti se ne vanno?")),
       subtitle = "Ogni linea rappresenta un giornalista",
       caption = "* Include solo giornalisti che hanno pubblicato almeno 52 giornalisti in un determinato anno") +
  theme_minimal(base_family = "Carlito") +
  theme(legend.position = "bottom", legend.title = element_blank(),
        legend.text = element_text(margin = margin(l =1, r = 10), hjust = 0))

ggsave(filename = "regularLeavePP_it.png", width = 20, height = 10, units = "cm")


read_csv(file = "allLeave_PP.csv") %>% 
  mutate(Working = str_replace_all(string = Working, pattern = "Working", replacement = "Attivo")) %>% 
  mutate(Working = str_replace_all(string = Working, pattern = "Joined", replacement = "Nuovo arrivo")) %>%
  mutate(Working = str_replace_all(string = Working, pattern = "Left", replacement = "Non più attivo")) %>% 
  mutate(Working = factor(x = Working, levels = c("Non più attivo", "Nuovo arrivo", "Attivo"))) %>%
  ggplot(aes(x = Year, stratum = Working, alluvium = author, fill = Working, label = Working)) +
  scale_fill_viridis_d(option = "D") +
  #scale_fill_brewer(type = "qual", palette = "Set2") +
  geom_flow(stat = "alluvium", lode.guidance = "rightleft",
            color = "darkgray") +
  geom_stratum() +
  scale_x_continuous("") +
  labs(title = expression(paste("Quanti giornalisti regolari arrivano a ", italic("Pervy Pridnestrovski"), " e quanti se ne vanno?")),
       subtitle = "Ogni linea rappresenta un giornalista") +
  theme_minimal(base_family = "Carlito") +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.text = element_text(margin = margin(l =1, r = 10), hjust = 0))

ggsave(filename = "allLeave_PP_it.png", width = 20, height = 10, units = "cm")



read_csv(file = "leftIn2017.csv") %>% 
  ggplot(mapping = aes(x = date, y = author, colour = LeftIn2017)) +
  scale_x_date(name = "") +
  scale_y_discrete("", labels = NULL) +
  scale_colour_viridis_d() +
  geom_point() +
  theme_minimal(base_family = "Carlito") +
  geom_vline(xintercept = c(as.numeric(as.Date("2016-12-11"))), linetype = 2) +
  guides(colour=FALSE) +
  labs(title = "Ogni linea rappresenta un giornalista, ogni punto un notizia",
       subtitle = "I due giornalisti che hanno abbandonato dopo il voto del 2016 sono evidenziati in viola.\nLa linea tratteggiata verticale indica il giorno del voto",
       caption = expression(paste("* Include solo collaboratori regolari di ", italic("Pervy Pridnestrovski"))))


ggsave(filename = "leftIn2017_it.png", width = 20, height = 10, units = "cm")
