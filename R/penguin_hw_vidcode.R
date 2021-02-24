# palmer penguins datavis re-engineering
# plot histogram of flipper lengths by species https://github.com/allisonhorst/palmerpenguins/blob/master/man/figures/README-flipper-hist-1.png

#install.packages("palmerpenguins")
library(ggplot2)
library(palmerpenguins)
library(patchwork)

penguin_cols = c("darkorange","darkorchid","cyan4")

# plot histogram of flipper length
head(penguins)

flipper_histogram = ggplot(penguins) +
  geom_histogram(aes(x=flipper_length_mm, fill=species), 
                 position='identity',
                 alpha=0.4) +
  theme_minimal() +
  xlab('Flipper Length (mm)') +
  ylab('Frequency') +
  ggtitle("Penguin Flipper Lengths") +
  theme(legend.position = c(0.9, 0.9)) +
  scale_fill_manual(values = penguin_cols)


# scatterplot of flipper length and body mass https://github.com/allisonhorst/palmerpenguins/blob/master/man/figures/README-mass-flipper-1.png
scatter_penguins = ggplot(penguins) +
  geom_point(aes(x=flipper_length_mm, 
                 y=body_mass_g, 
                 col=species, 
                 pch=species), 
             alpha=0.6) +
  theme_minimal() +
  scale_color_manual(values=penguin_cols) +
  xlab('Flipper Length (mm)') +
  ylab('Body Mass (g)') +
  theme(legend.position = c(0.1, 0.8)) +
  ggtitle(label="Penguin Size, Palmer Station LTER",
          subtitle = " Flipper length and body mass for Adelie, Chinstrap, and Gentoo penguins")


# put together with patchwork
finalplot = scatter_penguins / flipper_histogram
ggsave(plot=finalplot, 
       filename='penguinplots.png',
       height = 8,
       width = 6)
