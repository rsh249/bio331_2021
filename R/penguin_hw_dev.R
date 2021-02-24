# palmer penguins datavis re-engineering homework
#install.packages("palmerpenguins")
library(ggplot2)
library(palmerpenguins)
library(patchwork)
head(penguins)
head(penguins_raw)

penguin_cols = c("darkorange","darkorchid","cyan4")

#plot histogram of flipper lengths by species https://github.com/allisonhorst/palmerpenguins/blob/master/man/figures/README-flipper-hist-1.png

ggplot(data=penguins) +
  geom_histogram(aes(x=flipper_length_mm))

ggplot(data=penguins) +
  geom_histogram(aes(x=flipper_length_mm, fill=species), alpha=0.4) # default is identity='stack'

ggplot(data=penguins) +
  geom_histogram(aes(x=flipper_length_mm, fill=species), position='identity', alpha=0.4)

ggplot(data=penguins) +
  geom_histogram(aes(x=flipper_length_mm, fill=species), position='identity', alpha=0.4) + 
  theme_minimal() + 
  ylab('Frequency') +
  xlab('Flipper length (mm)') +
  scale_fill_manual(values = penguin_cols) +
  ggtitle('Penguin flipper lengths')

histoplot <- ggplot(data=penguins) +
  geom_histogram(aes(x=flipper_length_mm, fill=species), position='identity', alpha=0.4) + 
  theme_minimal() + 
  ylab('Frequency') +
  xlab('Flipper length (mm)') +
  scale_fill_manual(values = penguin_cols) +
  ggtitle('Penguin flipper lengths')

#plot scatterplot of flipper length and body mass https://github.com/allisonhorst/palmerpenguins/blob/master/man/figures/README-mass-flipper-1.png

ggplot(penguins) +
  geom_point(aes(x=flipper_length_mm, y=body_mass_g)) +
  theme_minimal()

ggplot(penguins) +
  geom_point(aes(x=flipper_length_mm, y=body_mass_g, col=species)) +
  theme_minimal() 

ggplot(penguins) +
  geom_point(aes(x=flipper_length_mm, y=body_mass_g, col=species)) +
  theme_minimal() + 
  scale_color_manual(values=penguin_cols)

ggplot(penguins) +
  geom_point(aes(x=flipper_length_mm, y=body_mass_g, col=species, pch=species)) +
  theme_minimal() + 
  scale_color_manual(values=penguin_cols)

ggplot(penguins) +
  geom_point(aes(x=flipper_length_mm, y=body_mass_g, col=species, pch=species)) +
  theme_minimal() + 
  scale_color_manual(values=penguin_cols)

ggplot(penguins) +
  geom_point(aes(x=flipper_length_mm, y=body_mass_g, col=species, pch=species), alpha = 0.7) +
  theme_minimal() + 
  scale_color_manual(values=penguin_cols)

ggplot(penguins) +
  geom_point(aes(x=flipper_length_mm, y=body_mass_g, col=species, pch=species), alpha = 0.7) +
  theme_minimal() + 
  scale_color_manual(values=penguin_cols) +
  xlab('Flipper length (mm)') +
  ylab('Body Mass (g)') +
  ggtitle('Penguin Size, Palmer Station LTER')

scatterpenguins = ggplot(penguins) +
  geom_point(aes(x=flipper_length_mm, y=body_mass_g, col=species, pch=species), alpha = 0.7) +
  theme_minimal() + 
  scale_color_manual(values=penguin_cols) +
  xlab('Flipper length (mm)') +
  ylab('Body Mass (g)') +
  ggtitle(label='Penguin Size, Palmer Station LTER',
          subtitle='Flipper length and body mass for Adelie, Chinstrap, and Gentoo penguins')

#if there is time move the legend
scatterpenguins = ggplot(penguins) +
  geom_point(aes(x=flipper_length_mm, y=body_mass_g, col=species, pch=species), alpha = 0.7) +
  theme_minimal() + 
  scale_color_manual(values=penguin_cols) +
  xlab('Flipper length (mm)') +
  ylab('Body Mass (g)') +
  theme(legend.position = c(0.2, 0.8)) +
  ggtitle(label='Penguin Size, Palmer Station LTER',
          subtitle='Flipper length and body mass for Adelie, Chinstrap, and Gentoo penguins')

histoplot <- ggplot(data=penguins) +
  geom_histogram(aes(x=flipper_length_mm, fill=species), position='identity', alpha=0.4) + 
  theme_minimal() + 
  ylab('Frequency') +
  xlab('Bill Length (mm)') +
  scale_fill_manual(values = penguin_cols) +
  theme(legend.position = c(0.9, 0.9)) +
  ggtitle('Penguin flipper lengths')

# put together with patchwork
histoplot + scatterpenguins
