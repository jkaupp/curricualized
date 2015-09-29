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
library(waffle)
library(rcdimple)

cmap.file <- "~/ownCloud/Faculty Outcomes Work/Department Data/Faculty-wide/Maps/Queen's Engineering Maps.xlsx"

c.levels = c(0:3)
c.labels = c("I","D","A")
test <- function(x) factor(x,levels=c.levels,labels=c.labels)

# Read in the raw map
data <- import(cmap.file,sheet="Test Map")

# Create the melted map
m.map <- gather(data,course,map,4:ncol(data)) %>% 
  mutate(Indicator = factor(Indicator),
         course = as.character(course)) %>% 
  rename(attribute = GA,
         level = map) %>% 
  set_names(tolower(names(.))) %>% 
  filter(complete.cases(.))

course.info <- data.frame(course=unique(m.map$course),
                          semester=c(1,1,2,1,1,1,1,1,3,3,3,3,3,4,4,4,4,5,5,5,5,5,5,5,5,6,6,7,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,8))
                      
                    


# Process the map 
tree.map <- m.map %>%
  group_by(program,course,attribute,indicator) %>% 
  summarize(n.assessed=sum(level)) %>% 
  group_by(program,course,attribute) %>% 
  mutate(n.indicator = n(),
         ga.assessed=sum(n.assessed)) %>% 
  data.frame()



## Attribute Coxcomb for Curriculum Mapping----
## Attribute level curriculum mapping. Provides vizualization of how mnay times an attribute is measured in a course
## Input is long-format/melted data frame key=indicator, value=value
ga.cxc <- function (m.df)
{
  attribute.colors <- data.frame(
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
      mutate(level = factor(level, labels = c.labels)) 
    
    dp <- dimple(
      x = "course",
      y =  c("program","attribute"),
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
    
    
    
# CEAB Reporting Samples: Stacked Bar for Attribute Maps ----
    ceab.stackedbar <- . %>%
    {
      inner_join(.,course.info) %>%
        mutate(level = factor(level, labels = c.labels)) %>%
        group_by(course,attribute,level) %>%
        distinct %>%
        group_by(attribute,level) %>%
        summarize(n = n()) %>%
        ggplot(aes(x = attribute, y = n)) +
        geom_bar(aes(fill = level), stat = "identity") +
        ylab("Number of Courses") +
        xlab("Attribute") +
        theme_light()
    }
    
# CEAB Reporting Samples: Stacked Bar by for Progession Maps ---- 
      
    ceab.semester.stackedbar <- . %>%
    {
      inner_join(.,course.info) %>%
        mutate(level = factor(level, labels = c.labels)) %>%
        group_by(course,attribute,level) %>%
        distinct %>%
        group_by(semester,level) %>%
        summarize(n = n()) %>%
        ggplot(aes(x = semester, y = n)) +
        geom_bar(aes(fill = level), stat = "identity") +
        ylab("Number of Courses") +
        xlab("Semester") +
        scale_x_continuous(breaks = 1:8) +
        theme_light()
    }
    
# CEAB Reporting Samples: Waffle Chart for Porportion ---- 
    
    ceab.ida.waffle <- . %>%
    {
      inner_join(.,course.info) %>%
        mutate(level = factor(level, labels = c.labels)) %>%
        group_by(course,attribute,level) %>%
        distinct %>%
        group_by(level) %>%
        summarize(n = n()) %>%
        select(n) %>%      
        unlist %>% 
        set_names(c("I","D","A")) %>% 
        waffle(
          size=0.5, 
          colors=c("#c7d4b6", "#a3aabd", "#a0d0de", "#97b5cf"), 
          title="Development focus of the program", 
          xlab="1 square == 1 course"
        )
    }    
    

    