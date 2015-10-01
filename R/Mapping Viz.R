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
library(stringr)
library(grid)
library(gridExtra)
library(extrafont)

cmap.file <-
  "~/ownCloud/Faculty Outcomes Work/Department Data/Faculty-wide/Maps/Queen's Engineering Maps.xlsx"

c.levels = c(1:3)
c.labels = c("I","D","A")

# Read in the raw map
data <- import(cmap.file,sheet = "Test Map")

# Create the melted map
m.map <- gather(data,course,map,4:ncol(data)) %>%
  mutate(
    Indicator = factor(Indicator),
    course = as.character(course),
    GA = factor(
      GA, levels = c(
        "KB","PA","IN","DE","ET","TW","CO","PR","IM","EE","EC","LL"
      ),labels =  c(
        "KB","PA","IN","DE","ET","TW","CO","PR","IM","EE","EC","LL"
      )
    )
  ) %>%
  rename(attribute = GA,
         level = map) %>%
  set_names(tolower(names(.))) %>%
  filter(complete.cases(.))

course.info <- data.frame(
  course = unique(m.map$course),
  semester = c(
    1,1,2,1,1,1,1,1,3,3,3,3,3,4,4,4,4,5,5,5,5,5,5,5,5,6,6,7,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,8
  )
) %>%
  mutate(course = as.character(course),
         year = str_extract(course, "\\d"))


# Process the map
tree.map <- m.map %>%
  group_by(program,course,attribute,indicator) %>%
  summarize(n.assessed = sum(level)) %>%
  group_by(program,course,attribute) %>%
  mutate(n.indicator = n(),
         ga.assessed = sum(n.assessed)) %>%
  data.frame()



## Attribute Coxcomb for Curriculum Mapping----
## Attribute level curriculum mapping. Provides vizualization of how mnay times an attribute is measured in a course
## Input is long-format/melted data frame key=indicator, value=value
ga.cxc <- function (m.df)
{
  attribute.colors <- data.frame(
    attribute = c(
      "KB","PA","IN","DE","ET","TW","CO","PR","IM","EE","EC","LL"
    ),
    color = viridis(12)
  )
  
  attribute.colors <-
    setNames(as.character(attribute.colors$color), attribute.colors$attribute)
  
  m.df %>%
    group_by(program,course,attribute,indicator,description) %>%
    summarize(n.assessed = sum(level)) %>%
    group_by(program,course,attribute) %>%
    mutate(n.indicator = n(),
           ga.assessed = sum(n.assessed)) %>%
    data.frame() %>%  {
      ggplot(., aes(x = attribute, y = ga.assessed)) +
        geom_bar(
          aes(fill = attribute, alpha = 0.5), colour = "#FFFFF3", width = 1, stat = "identity", position = "identity"
        ) +
        geom_abline(
          .,intercept = min(.$ga.assessed), slope = 0, linetype = 2
        ) +
        geom_abline(
          .,intercept = max(.$ga.assessed), slope = 0, linetype = 2
        ) +
        geom_text(
          aes(y = ga.assessed - 0.4, fontface = "bold"),label = .$ga.assessed, vjust =
            1
        ) +
        geom_text(aes(y = max(ga.assessed) + 2, fontface = "bold"), label = .$attribute, vjust =
                    1) +
        geom_segment(
          aes(
            x = attribute, xend = attribute, y = ga.assessed + 0.25, yend = max(ga.assessed) +
              0.75, color = "grey50"
          ), alpha = 0.5
        ) +
        coord_polar(theta = "x", start = 1) +
        scale_fill_manual(values = attribute.colors) +
        scale_y_continuous(minor_breaks = seq(0, max(.$ga.assessed),1)) +
        scale_color_identity() +
        theme(
          text = element_text(
            family = "Gill Sans MT", face = "bold", size = 22
          ),
          axis.line = element_blank(),
          axis.title = element_blank(),
          axis.text.y = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks = element_blank(),
          panel.border = element_blank(),
          panel.grid.major = element_blank(),
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
      "KB","PA","IN","DE","ET","TW","CO","PR","IM","EE","EC","LL"
    ),
    color = c(
      "#E12493", "#067F0A", "#08829F", "#F0A305", "#9E56E5", "#845508", "#B21C42", "#214A1E", "#B8AACC", "#97B438", "#B988EF", "#12B2B3"
    )
  ) %>%
    arrange(attribute)
  
  
  m.df %>%
    select(assessment, attribute, indicator, context) %>%
    distinct(assessment, attribute, indicator, context) %>%
    group_by(indicator) %>%
    mutate(n.indicator = n()) %>%
    distinct(indicator) %>%
    select(-assessment,-context) %>%
    arrange(attribute) %>%
    as.data.frame() %>%
    left_join(.,attribute.colors) %>%
    treemap(
      .,
      index = c("attribute","indicator"),
      vSize = "n.indicator",
      vColor = "color",
      type = "color",
      title = "",
      title.legend = "",
      fontsize.labels = c(32,16),
      fontface.labels = "bold",
      fontfamily.labels = "DejaVu Sans Condensed",
      fontcolor.labels = "#f0f0f0",
      lowerbound.cex.labels = 0.1,
      bg.labels = 0,
      position.legend = "none",
      align.labels = list(c("left","top"),c("right","bottom")),
      drop.unused.levels = TRUE
    )
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
  inner_join(.,course.info, by = "course") %>%
    mutate(level = factor(level, labels = c.labels)) %>%
    select(-indicator) %>%
    group_by(attribute, level) %>%
    unique %>%
    tally %>%
    ggplot(aes(x = attribute, y = n)) +
    geom_bar(aes(fill = level), stat = "identity") +
    ylab("Number of Courses") +
    xlab("Attribute") +
    scale_fill_brewer(palette = "Set1") +
    theme_light()
}


feas.IDA.bar <- . %>%
{
  inner_join(.,course.info, by = "course") %>%
    mutate(level = factor(level, labels = c.labels)) %>%
    select(-indicator) %>%
    group_by(attribute, level) %>%
    unique %>%
    tally %>%
    {
      ggplot(., aes(x = attribute, y = n)) +
        geom_bar(aes(fill = level), stat = "identity") +
        annotate(
          "segment", x = Inf, xend = -Inf, y = 0, yend = 0, colour = "grey50", lwd = 0.1
        ) +
        geom_hline(yintercept = seq(min(.$n), max(.$n) - 1, by = 1), color = "#FFFFFF") +
        coord_flip() +
        ylab("Number of Courses") +
        xlab("Attribute") +
        facet_wrap( ~ level) +
        scale_fill_brewer(name="", palette = "Set1") +
        theme_light() +
        theme(
          text = element_text(family = "DejaVu Serif", size = 18),
          strip.text.y = element_text(angle = 0, color = "grey50"),
          strip.text.x = element_text(angle = 0, color = "grey50"),
          panel.grid.major.x = element_blank(),
          panel.grid.major.y = element_line(colour = "grey50", size = 0.1),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          strip.background = element_rect(fill = "#FFFFFF")
        )
    }
}

# CEAB Reporting Samples: Stacked Bar by for Progession Maps ----
ceab.semester.stackedbar <- . %>%
{
    inner_join(.,course.info, by = "course") %>%
    mutate(level = factor(level, labels = c.labels)) %>%
    select(-indicator) %>%
    group_by(semester, level) %>%
    unique %>%
    tally %>%
    ggplot(aes(x = semester, y = n)) +
    geom_bar(aes(fill = level), stat = "identity") +
    ylab("Number of Courses") +
    xlab("Semester") +
    scale_x_continuous(breaks = 1:8) +
    scale_fill_brewer(palette = "Set1") +
    theme_light()
}

feas.IDA.progression <- . %>%
{
  m.map %>%   
  inner_join(.,course.info, by = "course") %>%
    mutate(level = factor(level, labels = c.labels)) %>%
    select(-indicator) %>%
    group_by(attribute, semester, level) %>%
    unique %>%
    tally %>%
    {
      ggplot(., aes(x = attribute, y = n)) +
        geom_bar(aes(fill = level), stat = "identity") +
        annotate(
          "segment", x = Inf, xend = -Inf, y = 0, yend = 0, colour = "grey50", lwd = 0.1
        ) +
        geom_hline(yintercept = seq(min(.$n), max(.$n) - 1, by = 1), color = "#FFFFFF") +
        coord_flip() +
        ylab("Number of Courses") +
        xlab("Attribute") +
        facet_grid(level ~ semester) +
        scale_fill_brewer(name = "", palette = "Set1") +
        theme_light() +
        theme(
          text = element_text(family = "DejaVu Serif", size = 18),
#           axis.text.x = element_text(size = 10),
#           axis.text.y = element_text(size = 10),
          axis.title.y = element_text(vjust=0.5),
          axis.title.x = element_text(vjust=-0.5),
          # strip.text.y = element_text(angle = 0, color = "grey50"),
          strip.text.y = element_blank(),
          strip.text.x = element_text(angle = 0, color = "grey50"),
          panel.grid.major.x = element_blank(),
          panel.grid.major.y = element_line(colour = "grey50", size = 0.1),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          strip.background = element_rect(fill = "#FFFFFF"),
          legend.position = "right"
        )
    }
}


# CEAB Reporting Samples:Pie Chart for Porportion ----

ceab.IDA.pie <- . %>%
{
    inner_join(.,course.info, by = "course") %>%
    mutate(level = factor(level, labels = c.labels)) %>%
    select(-indicator) %>%
    group_by(level) %>%
    unique %>%
    tally %>%
    mutate(per = round(n / sum(n) * 100,1)) %>%
    {
      ggplot(., aes(x = factor(1), y = n)) +
        geom_bar(aes(fill = level), stat = "identity", width = 1) +
        annotate(
          "text", x = 1, y = .$n[.$level == "I"] / 2, label = paste("I: ", .$per[.$level ==
                                                                                   "I"],"%")
        ) +
        annotate(
          "text", x = 1, y = .$n[.$level == "I"] + .$n[.$level == "D"] / 2, label = paste("D: ", .$per[.$level ==
                                                                                                         "D"],"%")
        ) +
        annotate(
          "text", x = 1, y = .$n[.$level == "I"] + .$n[.$level == "D"] + .$n[.$level ==
                                                                               "A"] / 2, label = paste("A: ", .$per[.$level == "A"],"%")
        ) +
        coord_polar(theta = "y") +
        xlab("") +
        ylab("") +
        theme_light() +
        theme(
          axis.text = element_blank(),
          strip.text.y = element_text(angle = 0, color = "grey50"),
          strip.text.x = element_text(angle = 0, color = "grey50"),
          panel.grid.major.x = element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          strip.background = element_rect(fill = "#FFFFFF")
        )
    }
}


feas.IDA.waffle <- . %>%
{
  inner_join(.,course.info, by = "course") %>%
    mutate(level = factor(level, labels = c.labels)) %>%
    select(-indicator) %>%
    group_by(level) %>%
    unique %>%
    tally %>%
    select(n) %>%
    unlist %>%
    set_names(c("I","D","A")) %>%
    waffle(
      rows = 10,
      size = 1,
      colors = brewer.pal(3, "Set1"),
      title = "Program",
      xlab = "1 square == 1 course"
    ) +
    labs(fill = "Test") +
    theme(text = element_text(family = "DejaVu Serif", size = 22),
          legend.position = "bottom",
          plot.margin = unit(c(1,1,1,1), "cm"))
}


ceab1 <- ceab.stackedbar(m.map)
ceab2 <- ceab.semester.stackedbar(m.map)
ceab3 <- ceab.IDA.pie(m.map)

feas1 <- feas.IDA.bar(m.map)
feas2 <- feas.IDA.progression(m.map)
feas3 <-  feas.IDA.waffle(m.map)

png("CAEB Reporting.png", width = 4800, height = 3000, res=300, type="cairo-png")
grid.arrange(ceab1,ceab2,ceab3, ncol=1)
dev.off()

png("FEAS Alternatives.png", width = 4800, height = 3000, res=200, type="cairo-png")
grid.arrange(feas3,feas1,feas2, layout_matrix = rbind(c(1,2),c(3,3)))
dev.off()


