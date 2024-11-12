library(tidyverse)
# https://www.htmlwidgets.org/

library(plotly)
library(DT)
library(leaflet)

ufos <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-06-25/ufo_sightings.csv")
head(ufos)

ufos <- ufos %>%
  mutate(date_time = mdy_hm(date_time), 
         date_documented = mdy(date_documented)) %>% 
  filter(ufo_shape != "NA")

# plotly for interactive bar charts
p <- ggplot(data = ufos, aes(x = ufo_shape)) +
  geom_bar(position = "dodge")
ggplotly(p)

# or interactive point graphs
plot_ly(ufos, x = ufos$date_documented, y = ufos$encounter_length, 
        text = paste("Shape:", ufos$ufo_shape),
        mode = "markers", color = ufos$ufo_shape)

# leaflet for geospatial mapping
pal <- colorQuantile("YlOrRd", NULL, n = 8)
leaflet(ufos) %>% 
  addTiles() %>%
  addCircleMarkers(color = ~pal(encounter_length))

# DT for interactive table
co_ufos <- ufos %>% 
  filter(state == "co")
datatable(co_ufos, options = list(pageLength = 5))









