## Test code for Curriculum mapping Visualization

library(rio)
library(plyr)
library(dplyr)
library(magrittr)
library(RColorBrewer)
library(treemap)
library(ggplot2)
library(tidyr)
library(viridis)
library(scales)
library(grid)
library(rcdimple)

cmap.file <- "~/ownCloud/Faculty Outcomes Work/Department Data/Faculty-wide/Maps/Queen's Engineering Maps.xlsx"

c.levels = c(0:3)
c.labels = c(NA,"I","D","A")
test <- function(x) factor(x,levels=c.levels,labels=c.labels)

# Read in the raw map
data <- import(cmap.file,sheet="FY-MAP")

# Create the melted map
m.map <- gather(data,course,map,5:ncol(c.map)) %>% 
  mutate(Indicator = factor(Indicator),
         course = factor(course)) %>% 
  rename(attribute = GA,
         level = map) %>% 
  set_names(tolower(names(.)))

# Process the map 
tree.map <- m.map %>%
  group_by(program,course,attribute,indicator,description) %>% 
  summarize(n.assessed=sum(level)) %>% 
  group_by(program,course,attribute) %>% 
  mutate(n.indicator = n(),
         ga.assessed=sum(n.assessed)) %>% 
  data.frame()




#OLD ---Using the treemap package ---- 

treemap(tree.map,
        index = c("ga","indicator"),
        vSize = "ga.assessed",
        vColor = "n.assessed",
        title = "EDPS 101 Curriculum, Area = # of assessments per attribute",
        title.legend = "# of assessments per indicator",
        type = "manual",
        palette=brewer.pal(7,"YlGn"),
        fontsize.labels = c(16,0),
        fontcolor.labels = "#000000",
        lowerbound.cex.labels = 0.1,
        range = c(0,3),
        bg.labels = 0,
        drop.unused.levels = TRUE)


## Attribute Coxcomb for Curriculum Mapping----
## Attribute level curriculum mapping. Provides vizualization of how mnay times an attribute is measured in a course
## Input is long-format/melted data frame key=indicator, value=value
ga.cxc <- function (m.df)
{
  attribute.colors <- data_frame(
    attribute = c(
      "KB","PA","IN","DE","ET","TW","CO","PR","IM","EE","EC","LL"),
    color = viridis(12))
  
  attribute.colors <- setNames(as.character(attribute.colors$color), attribute.colors$attribute)
  
 m.df %>% 
   group_by(program,course,attribute,indicator,description) %>% 
    summarize(n.assessed=sum(level)) %>% 
    group_by(program,course,attribute) %>% 
    mutate(n.indicator = n(),
           ga.assessed=sum(n.assessed)) %>% 
    data.frame() %>%  {
      ggplot(., aes(x = attribute, y = ga.assessed)) +
        geom_bar(aes(fill = attribute, alpha = 0.5), colour="#FFFFF3", width = 1, stat = "identity", position = "identity" ) +
        geom_abline(.,intercept = min(.$ga.assessed), slope = 0, linetype = 2) +
        geom_abline(.,intercept = max(.$ga.assessed), slope = 0, linetype = 2) +
        geom_text(aes(y = ga.assessed-0.4, fontface="bold"),label = .$ga.assessed, vjust=1) +
        geom_text(aes(y = max(ga.assessed) + 2, fontface="bold"), label = .$attribute, vjust=1) +
        geom_segment(aes(x=attribute, xend=attribute, y=ga.assessed+0.25, yend=max(ga.assessed)+0.75, color = "grey50"), alpha = 0.5) +
        coord_polar(theta = "x", start = 1) +
        scale_fill_manual(values=attribute.colors) +
        scale_y_continuous(minor_breaks = seq(0, max(.$ga.assessed),1)) +
        scale_color_identity() +
        theme(
          text = element_text(family="Gill Sans MT", face="bold", size = 22),
          axis.line = element_blank(),
          axis.title = element_blank(),
          axis.text.y = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks = element_blank(),
          panel.border = element_blank(),
          panel.grid.major= element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.minor = element_blank(),
          legend.position = "none",
          strip.text.y = element_text(size = 14, angle = 0),
          strip.text.x = element_text(size = 14),
          panel.background = element_rect(fill = "#FFFFFF"),
          strip.background = element_rect(fill = "#FFFFFF"),
          plot.background = element_rect(fill = "#FFFFFF"),
          panel.margin = unit(0.5, "lines")
        )
    }
}


## Attribute Treemap for Curriculum Mapping----
## Needs alteration to work from curriculum mapping files.
# Input is long-format/melted data frame key=indicator, value=value
c.tree <- function (m.df)
{
  attribute.colors <- data.frame(
    attribute = c(
      "KB","PA","IN","DE","ET","TW","CO","PR","IM","EE","EC","LL"),
    color = c("#E12493", "#067F0A", "#08829F", "#F0A305", "#9E56E5", "#845508", "#B21C42", "#214A1E", "#B8AACC", "#97B438", "#B988EF", "#12B2B3" )
  ) %>% 
    arrange(attribute)
  
  
  m.df %>%
    select(assessment, attribute, indicator, context) %>%
    distinct(assessment, attribute, indicator, context) %>%
    group_by(indicator) %>%
    mutate(n.indicator=n()) %>%
    distinct(indicator) %>%
    select(-assessment,-context) %>%
    arrange(attribute) %>% 
    as.data.frame() %>% 
    left_join(.,attribute.colors) %>% 
    treemap(.,
            index = c("attribute","indicator"),
            vSize = "n.indicator",
            vColor = "color",
            type = "color",
            title="",
            title.legend="",
            fontsize.labels = c(32,16),
            fontface.labels = "bold",
            fontfamily.labels = "DejaVu Sans Condensed",
            fontcolor.labels = "#f0f0f0",
            lowerbound.cex.labels = 0.1,
            bg.labels = 0,
            position.legend = "none",
            align.labels = list(c("left","top"),c("right","bottom")),
            drop.unused.levels = TRUE)
}


# Using Dimple-----
#  Can look at grouping the X axis by year and course to look at entire programs
#  Auto-aggregate may be an issue, in which case need to create unqiue IDs for each.

    data <- m.map %>%
      mutate(level = factor(level,c.levels,c.labels))
    
    dp <- dimple(
      x = "course",
      y =  "attribute",
      groups = "level",
      data = data,
      type = "bar"
    ) %>%
      yAxis(type = "addCategoryAxis") %>%
      xAxis(type = "addCategoryAxis") %>%
      add_legend()
    
    # remove the rects
    dp$x$options$tasks <- list(
      htmlwidgets::JS(
        'function(){
        d3.selectAll(
        d3.select(this).selectAll("rect")[0]
        .filter(function(d){
        return d3.select(d).datum().aggField[0] === null }
        )
        ).remove()
        }'
  )
    )
    

#Using d3 packages ----
library(R2D3)
library(networkD3)


JSON<-jsonNestedData(structure=tree.map[,c(2:4)], values=tree.map[,7], top_label = "FEAS")

Flare <- rjson::fromJSON(JSON[[2]])

D3Tree(JSON, file_out="Tree.html")
D3Dendro(JSON, file_out="Dendro.html", width=1920, collapsible = TRUE)
treeNetwork(List = Flare, fontSize = 14, opacity = 0.9)
