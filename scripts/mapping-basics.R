
## Set up ----

# install packages if you don't already have them
install.packages("ggspatial")
install.packages("patchwork")
install.packages("rnaturalearth")

# load packages
library(ggplot2)
library(sf)
library(ggspatial)
library(patchwork)
library(rnaturalearth)

# load data
data <- readRDS(here::here("data", "data.RDS"))
# basemap of Nova Scotia and New Brunswick
nova.scotia <- data$nova_scotia

## 1. Simple study area map, including inset
study.area <- ggplot() +
  geom_sf(data = nova.scotia, linewidth = 0.1) +
  
  # label provinces/states
  annotate(geom = "text", x = -62.8, y = 45.3, label = "Nova\nScotia",
           lineheight = 0.9) +
  annotate(geom = "text", x = -66, y = 46.3, label = "New\nBrunswick",
           lineheight = 0.9) +
  annotate(geom = "text", x = -69, y = 44.93, label = "Maine") +
  
  # label ocean
  annotate(geom = "text", x = -62, y = 44.2, label = "Atlantic Ocean",
           fontface = "italic", colour = "dodgerblue") +
  
  # add scale bar
  annotation_scale(width_hint = 0.35, style = "bar",
                   text_cex = 0.9) + 
  # width_hint is how you change the distance represented by the scalebar
  
  # add north arrow
  annotation_north_arrow(location = "br", 
                         height = unit(0.9, "cm"), width = unit(0.6, "cm"),
                         which_north = "true") +

  coord_sf(expand = FALSE) +
  scale_y_continuous(breaks = c(44, 45, 46, 47)) +
  
  theme_bw() +
  theme(panel.grid = element_blank(),
        axis.text = element_text(size = 12))
study.area

## 2. Add in an inset map ----

# get broader area from RNaturalEarth
north.america <- rnaturalearth::ne_countries(scale = "large",
  continent = "north america", returnclass = "sf")

st_bbox(nova.scotia)

inset <- ggplot() +
  geom_sf(data = north.america, linewidth = 0.2) +
  
  annotate(geom = "rect", xmin = -70, xmax = -59.67305,
           ymin = 43.39125, ymax = 47.5, fill = NA,
           colour = "black", linewidth = 0.8) +
  
  coord_sf(xlim = c(-100, -30), ylim = c(12, 70),
           expand = FALSE) +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.title = element_blank(), 
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "none",
        plot.background = element_blank(),
        plot.margin = unit(c(0, 0, 0, 0), "cm"),
        axis.ticks.length.x = unit(0,'pt'))
inset

study.area + inset_element(inset, left = -0.01, bottom = 0.50,
                           right = 0.27, top = 1.00, align_to = "panel")
