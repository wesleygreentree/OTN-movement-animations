
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
bc.coast <- readRDS("data/bc-coast.RDS")

## 1. Simple study area map, including inset
study.area <- ggplot() +
  geom_sf(data = bc.coast, linewidth = 0.1) +
  
  # label areas of interest
  annotate(geom = "text",
           x = -125.65, y = 49.7, 
           label = "Vancouver\nIsland",
           size = 4.2, lineheight = 0.75, colour = "black") +
  
  annotate(geom = "text",
           x = -127, y = 48.6,
           label = "Pacific Ocean",
           fontface = "italic",
           size = 4.2, colour = "steelblue") +
  
  # add scale bar
  annotation_scale(width_hint = 0.35, style = "bar",
                   text_cex = 1) + 
  # width_hint is how you change the distance represented by the scalebar
  
  # add north arrow
  annotation_north_arrow(location = "tl", 
                         height = unit(0.9, "cm"), width = unit(0.6, "cm"),
                         which_north = "true") +

  coord_sf(xlim = c(-129.2, -121.8), ylim = c(47.3, 51.7),
           expand = FALSE) +

  theme_bw() +
  theme(panel.grid = element_blank(),
        axis.text = element_text(size = 14))
study.area

## 2. Add in an inset map ----

# get broader area from RNaturalEarth
north.america <- rnaturalearth::ne_countries(scale = "medium",
  continent = "north america", returnclass = "sf")
inset <- ggplot() +
  geom_sf(data = north.america) +
  
  annotate(geom = "rect", xmin = -129.2, xmax = -121.8,
           ymin = 47.3, ymax = 51.7, fill = NA,
           colour = "black", linewidth = 0.6) +
  
  coord_sf(xlim = c(-178, -105), ylim = c(18, 66),
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

# you have to trial-and-error to get the inset to fit where you
# want it to go
study.area + inset_element(inset, left = 0.693, bottom = 0.702,
                           right = 1.00, top = 1.00, align_to = "panel")
ggsave("figures/bc-map.PNG",
       width = 17, height = 16, units = "cm")
