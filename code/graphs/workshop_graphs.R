library(tidyverse)
library(ggplot2)
library(scales)
library(grid)
library(ggthemes)
library(readxl)
library(ggmap)
library(maps)
library(mapdata)
library(tools)

### Functions

manual_theme <- theme_minimal() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), axis.text = element_blank(),
          axis.title = element_blank(),
          legend.key.size = unit(0.5, "cm"), legend.key.width = unit(2, "cm"),
          legend.direction = "horizontal", legend.position = "bottom",
          plot.title = element_text(hjust = 0.5))


# Params

plot_width  <- 8
plot_height <- 5


### Import Data

setwd(dirname(rstudioapi::getSourceEditorContext()$path))
folder <- '../../data/'

plant_data <- read_excel(paste0(folder, 'EIA/plantlocations_04_2019.xlsx'))
map_data_state  <- map_data("state")
map_data_county <- map_data("county")

ercot_load_data <- read_csv(
    paste0(folder, 'electricity/elc_load_hourly_20190601_ercot.csv'))
ercot_gen_data <- read_csv(
    paste0(folder, 'other/solar_gen_hourly_20190601_ercot.csv'))


### Clean data

## Ercot data

ercot_load_data <- ercot_load_data[,c(
    'DeliveryDate', 'HourEnding', 'ActualLoad')]

ercot_gen_data <- ercot_gen_data[,c(
    'DELIVERY_DATE', 'HOUR_ENDING', 'ACTUAL_SYSTEM_WIDE')]

colnames(ercot_load_data) <- c('Date', 'Hour', 'Load')
colnames(ercot_gen_data)  <- c('Date', 'Hour', 'SolarGen')

ercot_data <- merge(ercot_load_data, ercot_gen_data, by = c('Date', 'Hour'))
ercot_data <- filter(ercot_data, Date == '6/1/2019')

## Plant data

# Ignore Alaska and Hawaii
plant_data <- filter(plant_data,
                     `Plant State` != 'AK',
                     `Plant State` != 'HI')
# Rename col
plant_data$Capacity <- plant_data$`Nameplate Capacity (MW)`


### Plot

## Geo Hydro plants

rel_renew_plot <- ggplot() +
    geom_polygon(data = map_data_state, color = 'grey70', fill = 'white',
                 aes(x = long, y = lat, group = group)) +
    geom_point(data = filter(
        plant_data, grepl('Geo', Technology) | grepl('Hydro', Technology)),
               aes(x = Longitude, y = Latitude, size = Capacity,
                   color = Technology),
               alpha = 0.5,
               stroke = 0, shape = 16) +
    guides(color = guide_legend(override.aes = list(size=5))) +
    manual_theme +
    theme(legend.box = "vertical",
          legend.margin = margin(-0.25,0,0,0, unit="cm"),
          legend.background = element_rect(fill = '#FAFAFA', color = '#FAFAFA'),
          panel.background = element_rect(fill = '#FAFAFA', color = '#FAFAFA'),
          plot.background = element_rect(fill = '#FAFAFA', color = '#FAFAFA'))

print(rel_renew_plot)
ggsave('../../documents/exhibits/rel_renew_map.pdf',
       width = plot_width, height = plot_height, dpi = 600)

## Ercot data

ercot_plot <- ggplot(data = ercot_data) +
    geom_line(aes(x = Hour, y = Load, color = 'Load'), size = 1) +
    geom_line(aes(x = Hour, y = SolarGen*50, color = 'SolarGen'), size = 1) +
    ylab('Load (MW)\n') +
    scale_y_continuous(expand = c(0.01,0),
        sec.axis = sec_axis(~./50, name = "Solar Generation (MW)\n"),
        breaks = c(0,500,1000,1500)*50) +
    scale_x_continuous(breaks = seq(0,25,2)) +
    scale_colour_manual(values = c("#23373B", "#EB811B")) +
    expand_limits(x = 0, y = 0) +
    labs(title = 'ERCOT Hourly Load and Solar Generation (6/1/2019)') +
    theme(legend.box = "vertical", legend.key.size = unit(0.5, "cm"),
          legend.key.width = unit(2, "cm"), legend.title = element_blank(),
          legend.direction = "vertical", legend.position = c(0.15, 0.9),
          legend.margin = margin(-0.25,0,0,0, unit="cm"),
          legend.background = element_rect(fill = '#FAFAFA', color = '#FAFAFA'),
          panel.background = element_rect(fill = '#FAFAFA', color = '#FAFAFA'),
          plot.background = element_rect(fill = '#FAFAFA', color = '#FAFAFA'),
          axis.line.x.bottom = element_line(size = 0.5, colour = "grey50"),
          axis.line.y.left = element_line(size = 0.5, colour = "grey50"),
          panel.grid.major = element_line(color = 'grey90'))

print(ercot_plot)
ggsave('../../documents/exhibits/ercot_load.pdf',
       width = plot_width*1.25, height = plot_height*0.9, dpi = 600)




