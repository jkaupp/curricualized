## Test code for Curriculum mapping Visualization

library(rio)
library(plyr)
library(dplyr)
library(magrittr)
library(reshape2)
library(RColorBrewer)
library(treemap)
library(ggplot2)
library(tidyr)

cmap.file <- "~/ownCloud/Faculty Outcomes Work/Department Data/Faculty-wide/Maps/Queen's Engineering Maps.xlsx"

levels = c(0:5)
labels = c("T, A","T, U","U, A","T","U","A")
test <- function(x) factor(x,levels=levels,labels=labels)

data <- import(cmap.file,sheet="FY-MAP")

c.map <- data[,c(5:17)] %>% 
  colwise(test)() %>% 
  cbind(data[,c(1:4)],.)

m.data <- melt(data,c("Program", "GA","Indicator", "Description"),c(5:17)) 

names(m.data) %<>%
  tolower()

# Changed to course view.
tree.map <- m.data %>%
  filter(variable=="APSC 101") %>% 
  group_by(program,ga,indicator,description) %>% 
  summarize(n.assessed=sum(value))

ga.lookup <- tree.map %>% 
  group_by(program,ga,indicator,description) %>% 
  count(ga)

names(ga.lookup) <- c("ga","n.indicators")

tree.map %<>% 
  join(.,ga.lookup, by="ga")

tree.map %<>% 
  group_by(ga) %>% 
  mutate(ga.assessed=sum(n.assessed))

tree.map %<>%
  as.data.frame()

#Using the treemap package ----

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

ga.nodes <- tree.map %>% 
  group_by(ga) %>% 
  summarize(mean(ga.assessed))

names(ga.nodes) <- c("node","size")

ind.nodes <- tree.map[,c(2:3)]
names(ind.nodes) <- c("node","size")
  
nodes.size <- c(15,ga.nodes$size,ind.nodes$size)
 
treegraph(tree.map,index=c("ga","indicator"),
          directed = FALSE,
          show.labels = FALSE,
          rootlabel = "First Year Attributes \n& Indicators",
          vertex.layout=igraph::layout.reingold.tilford,
          vertex.layout.params = c(circular=FALSE),
          vertex.label.cex = 0.7,
          mai = c(0.5, 0.5, 0.5, 0.5))

#Using d3 packages ----
library(R2D3)
library(networkD3)


JSON<-jsonNestedData(structure=tree.map[,c(2:4)], values=tree.map[,7], top_label = "FEAS")

Flare <- rjson::fromJSON(JSON[[2]])

D3Tree(JSON, file_out="Tree.html")
D3Dendro(JSON, file_out="Dendro.html", width=1920, collapsible = TRUE)
treeNetwork(List = Flare, fontSize = 14, opacity = 0.9)
