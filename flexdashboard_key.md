---
title: "US UFO Sightings in Colorado"
output: 
  flexdashboard::flex_dashboard:
    orientation: columns
    vertical_layout: fill
---

```{r setup, include=FALSE}
library(flexdashboard)
library(tidyverse)
library(leaflet)
library(plotly)
library(DT)
library(ggthemes)
library(viridis)
ufo_sightings <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-06-25/ufo_sightings.csv")

```
```{r clean, include = FALSE}

#filter to US only/adjust date/add year column
ufo_sightings_co <- ufo_sightings %>% 
  mutate(date_time = mdy_hm(date_time),
         sighting_year = year(date_time)) %>% 
  filter(state == 'co')

```


Column {data-width=650}
-----------------------------------------------------------------------

### All sightings in Colorado

```{r}
pal <- colorQuantile("YlOrRd", NULL, n = 8)
leaflet() %>% 
  addTiles() %>% 
  fitBounds(-102.03,37,-109.03, 41) %>% 
  addTiles() %>% 
  addCircleMarkers(ufo_sightings_co$longitude, 
                   ufo_sightings_co$latitude, 
                   color = ufo_sightings_co$encounter_length, 
                   radius = 5, 
                   fill = T,
                   fillOpacity = 0.2,
                   opacity = 0.6,
                   popup = paste(ufo_sightings_co$city_area,
                                 ufo_sightings_co$sighting_year, 
                                 sep = ",")) 

```

Column {data-width=350}
-----------------------------------------------------------------------

### Sightings in Colorado by Year

```{r}
ufo_sightings_co %>% 
  group_by(sighting_year) %>% 
  summarize(n_year = n()) %>% 
  ungroup() %>% 
  ggplot() +
  geom_line(aes(x = sighting_year, y = n_year)) +
  labs(title = "UFO Sightings in Colorado per Year", x = "Year", y = "Sighting Count") +
  theme_few()
  

```

### Data
```{r}
ufo_sightings_filtered <- ufo_sightings_co %>% 
  select(city_area, sighting_year)
```

```{r}
datatable(ufo_sightings_filtered, colnames = c("Location", "Year"), 
extensions = "Scroller", style="bootstrap", class="compact", 
width="100%", options=list(deferRender=TRUE, scrollY=300, scroller=TRUE))
```
