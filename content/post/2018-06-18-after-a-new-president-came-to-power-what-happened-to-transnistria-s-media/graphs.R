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
  scale_y_continuous(name = "Number of articles") +
  scale_x_continuous(name = "", breaks = scales::pretty_breaks(n = 5)) +
  theme_minimal(base_family = "Carlito") +
  labs(title = "Most news items include the name of the journalist who produced them",
       subtitle = expression(paste("Total news items published on ", italic("Pervy Pridnestrovski"), " between January 2012 and May 2018")), 
       caption = "* For 2018, data includes only publications issued before 30 May 2018")

ggsave(filename = "authorAvailablePP.png", width = 20, height = 10, units = "cm")


read_csv("regularContributorsPP.csv") %>% 
  ggplot(mapping = aes(x = Year, y = nn, fill = Regular)) +
  geom_col(colour = "black") +
  scale_fill_viridis_d(guide = guide_legend(title = NULL)) +
  scale_y_continuous(name = "Number of journalists") +
  scale_x_continuous(name = "", breaks = scales::pretty_breaks(n = 5)) +
  theme_minimal(base_family = "Carlito") +
  labs(title = expression(paste("About half of journalists credited, appear routinely on ", italic("Pervy Pridnestrovski"))),
       subtitle = expression(paste("Total number of journalists credited on ", italic("Pervy Pridnestrovski"), " between January 2012 and May 2018")))

ggsave(filename = "regularContributorsPP.png", width = 20, height = 10, units = "cm")


read_csv("articlesByRegular_PP.csv") %>% 
  ggplot(mapping = aes(x = Year, y = nn, fill = Regular)) +
  geom_col(colour = "black") +
  scale_fill_viridis_d(guide = guide_legend(title = NULL)) +
  scale_y_continuous(name = "Number of articles") +
  scale_x_continuous(name = "", breaks = scales::pretty_breaks(n = 5)) +
  theme_minimal(base_family = "Carlito") +
  labs(title = "A core group of regular contributors produces most of the credited news items",
       subtitle = expression(paste("Total news items published on ", italic("Pervy Pridnestrovski"), " between January 2012 and May 2018")))

ggsave(filename = "articlesByRegular_PP.png", width = 20, height = 10, units = "cm")

## Alluvial

read_csv(file = "regularLeavePP.csv") %>% 
  ggplot(aes(x = Year, stratum = Working, alluvium = author, fill = Working, label = Working)) +
  scale_fill_viridis_d(option = "D") +
  #scale_fill_brewer(type = "qual", palette = "Set2") +
  geom_flow(stat = "alluvium", lode.guidance = "rightleft",
            color = "darkgray") +
  geom_stratum() +
  scale_x_continuous("") +
  labs(title = expression(paste("How many regular contributors join ", italic("Pervy Pridnestrovski"), ", how many leave?")), subtitle = "Each line represents a journalist", caption = "* Includes only contributors credited with at least 52 items in any given year") +
  theme_minimal(base_family = "Carlito") +
  theme(legend.position = "bottom", legend.title = element_blank(),
        legend.text = element_text(margin = margin(l =1, r = 10), hjust = 0))

ggsave(filename = "regularLeavePP.png", width = 20, height = 10, units = "cm")


read_csv(file = "allLeave_PP.csv") %>% 
  ggplot(aes(x = Year, stratum = Working, alluvium = author, fill = Working, label = Working)) +
  scale_fill_viridis_d(option = "D") +
  #scale_fill_brewer(type = "qual", palette = "Set2") +
  geom_flow(stat = "alluvium", lode.guidance = "rightleft",
            color = "darkgray") +
  geom_stratum() +
  scale_x_continuous("") +
  labs(title = expression(paste("How many contributors join ", italic("Pervy Pridnestrovski"), ", how many leave?")), subtitle = "Each line represents a journalist") +
  theme_minimal(base_family = "Carlito") +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.text = element_text(margin = margin(l =1, r = 10), hjust = 0))

ggsave(filename = "allLeave_PP.png", width = 20, height = 10, units = "cm")
