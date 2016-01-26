library(rio)
library(magrittr)
library(dplyr)
library(tidyr)
library(stringr)
library(grid)
library(gridExtra)


AU_Check <- function(df) {
 
   counts<-df %>% 
    select(Math:ED) %>% 
    summarise_each(funs(sum))
  
  if (counts$Math < 195)
  {
    warning("MATH AUs < 195")
  }
  else
    if (counts$NS < 195)
    {
      warning("NS AUs < 195")
    }
  else
    if (counts$CS < 225)
    {
      warning("CS AUs < 225")
    }
  else
    if (counts$ES < 225)
    {
      warning("ES AUs < 225")
    }
  else
    if (counts$ED < 225)
    {
      warning("ED AUs < 225")
    }
  else
    if (counts$Math + counts$NS < 420)
    {
      warning("MATH + NS AUs < 420")
    }
  else
    if (counts$ES + counts$ED < 900)
    {
      warning("MATH + NS AUs < 900")
    }
  else
    if (sum(counts) < 1950)
    {
      warning("Total AUs < 1950; Program AU Count = ",sum(counts))
    }
  
}  

# Color Palettes
attribute.colors <- data.frame(
  attribute = c(
    "KB","PA","IN","DE","ET","TW","CO","PR","IM","EE","EC","LL"),
  attribute.color = c("#E12493", "#067F0A", "#08829F", "#F0A305", "#9E56E5", "#845508", "#B21C42", "#214A1E", "#B8AACC", "#97B438", "#B988EF", "#12B2B3" )
) %>% 
  arrange(attribute)

au.colors <- data.frame(
  AU = c(
    "Math","NS","CS","ES","ED"),
  au.color = RColorBrewer::brewer.pal(5, "Set1")
) 

udle.colors <- data.frame(
  U1 = c(
    "1","2","3a","3b","4","5","6"),
  udle.color = c("#E12493", "#067F0A", "#08829F", "#F0A305", "#9E56E5", "#845508", "#FF7F00")
) 


## Curriculum list data, from Jim Mason's Excel masters ----
data.dir <- "/Users/Jake/ownCloud/FEAS/CEAB/Faculty Course Lists/"

masters <- list.files(paste0(data.dir, "Masters/"), full.names  = TRUE) %>% 
  lapply(import, skip = 2)

masters[[1]] %<>% 
  mutate(`SHORT COURSE TITLE` = as.character(`SHORT COURSE TITLE`),
         `Academic year` = "2014-2015") 

masters[[2]] %<>% 
  mutate(`SHORT COURSE TITLE` = as.character(`SHORT COURSE TITLE`),
         `Academic year` = "2015-2016")


masters %<>%
  bind_rows() %>% 
  filter(!is.na(`COURSE CODE`)) %>% 
  mutate(Department = str_sub(`COURSE CODE`, 1, 4)) %>% 
  select(`Academic year`, Department, everything()) %>% 
  dplyr::rename(`Course Code` = `COURSE CODE`)

mech.program <- import(paste0(data.dir,"Programs.xlsx"), sheet="MECH")


# Course List for Program
mech.program %>% 
  filter(Option == "CORE" | Option == "ME1") %>% 
  select(`Course Code`)

## Functions for Plotting ----
vplayout <- function(x, y) viewport(width=25, height=14, layout.pos.row = x, layout.pos.col = y)

## AU Treemap ----
program_au_tree <- function (df,year,x,y)
{
 
  df %>% 
  select(`Academic year`, Program, Option, Year, `Course Code`, Math:ED, Credits) %>% 
    filter(Year == year) %>% 
    gather(AU,Value,Math:ED) %>% 
    left_join(au.colors) %>% 
    {treemap(
      .,
      index = c("AU","Course Code"),
      vSize = "Value",
      vColor = "au.color",
      type = "color",
      title = paste0("MECH Program CEAB AU Mapping:", year),
      title.legend = "",
      fontsize.labels = c(28,14),
      fontface.labels = c("bold","plain"),
      fontcolor.labels = "#f0f0f0",
      lowerbound.cex.labels = 0.1,
      bg.labels = 0,
      border.col = "#ffffff",
      position.legend = "none",
      align.labels = list(c("left","top"), c("right","bottom")),
      vp = vplayout(x,y)
    )
    }
}

## GA Treemap ----
program_ga_tree <- function (df,year,x,y)
{
  df %>%
#     filter(academic_year == "2014-2015", program_year==year) %>%
#     distinct(assessment, attribute, indicator, context) %>%
#     group_by(indicator, attribute, course_code) %>%
#     tally %>%
#     arrange(attribute) %>%
    filter(program_year==year) %>%
    distinct(attribute, indicator, course_code) %>%
    group_by(indicator, attribute, course_code) %>%
    tally %>%
    arrange(attribute) %>% 
    left_join(attribute.colors) %>% 
    {treemap(
      .,
      index = c("attribute","course_code"),
      vSize = "n",
      vColor = "attribute.color",
      type = "color",
      title = paste0("MECH Program CEAB GA Mapping:", year),
      title.legend = "",
      fontsize.labels = c(28,14),
      fontface.labels = c("bold","plain"),
      fontcolor.labels = "#f0f0f0",
      lowerbound.cex.labels = 0.1,
      bg.labels = 0,
      border.col = "#ffffff",
      position.legend = "none",
      align.labels = list(c("left","top"), c("right","bottom")),
      vp = vplayout(x,y)
    )
    }
}

## UDLE Treemap ----
program_udle_tree <- function (df,year,x,y)
{
 df %>%
    filter(program_year == year) %>%
    distinct(U1, U2, course_code) %>%
    group_by(U1, U2, course_code) %>%
    tally %>%
    arrange(U1) %>% 
    left_join(udle.colors) %>% 
    filter(!is.na(U1)) %>% 
    {treemap(
      .,
      index = c("U1","U2","course_code"),
      vSize = "n",
      vColor = "udle.color",
      type = "color",
      title = paste0("MECH Program UDLE Mapping:", year),
      title.legend = "",
      fontsize.labels = c(28,28,14),
      fontface.labels = c("bold","bold","plain"),
      fontcolor.labels = "#f0f0f0",
      lowerbound.cex.labels = 0.1,
      bg.labels = 0,
      border.col = "#ffffff",
      border.lwds = c(1,5,1),
      position.legend = "none",
      align.labels = list(c("left","top"), c("right","top"), c("right","bottom")),
      vp = vplayout(x,y)
    )
    }
}

## Composite Program AU Map Function----
au_maps <- function(df) {
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(1, 4)))
  par(mai=c(0,0,0,0))
  
  program_au_tree(df,"First Year",1,1)
  program_au_tree(df,"Second Year",1,2)
  program_au_tree(df,"Third Year",1,3)
  program_au_tree(df,"Fourth Year",1,4)
}

## Composite Program GA Map Function----
ga_maps <- function(df) {
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(1, 4)))
  par(mai=c(0,0,0,0))
  
  program_ga_tree(df,"First Year",1,1)
  program_ga_tree(df,"Second Year",1,2)
  program_ga_tree(df,"Third Year",1,3)
  program_ga_tree(df,"Fourth Year",1,4)
  
}

## Composite Program UDLE Map Function----
udle_maps <- function(df) {
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(1, 4)))
  par(mai=c(0,0,0,0))
  
  program_udle_tree(df,"First Year",1,1)
  program_udle_tree(df,"Second Year",1,2)
  program_udle_tree(df,"Third Year",1,3)
  program_udle_tree(df,"Fourth Year",1,4)
  
}

## Join GA, AU, UDLE Maps ----
joint_maps <- function(au.df,ga.df) {
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(3, 4)))
  par(mai=c(0,0,0,0))
  
  program_au_tree(au.df,"First Year",1,1)
  program_au_tree(au.df,"Second Year",1,2)
  program_au_tree(au.df,"Third Year",1,3)
  program_au_tree(au.df,"Fourth Year",1,4)
  program_ga_tree(ga.df,"First Year",2,1)
  program_ga_tree(ga.df,"Second Year",2,2)
  program_ga_tree(ga.df,"Third Year",2,3)
  program_ga_tree(ga.df,"Fourth Year",2,4)
  program_udle_tree(ga.df,"First Year",3,1)
  program_udle_tree(ga.df,"Second Year",3,2)
  program_udle_tree(ga.df,"Third Year",3,3)
  program_udle_tree(ga.df,"Fourth Year",3,4)
}


# Produce AU Maps ----
pdf("AU Maps.pdf", width=27.5, height=21.25)
masters %>%
  filter(`Academic year` == "2015-2016") %>% 
  inner_join(mech.program %>% 
               filter(Option == "CORE" | Option == "ME1"), by="Course Code") %>% 
  mutate(Year = factor(Year, levels=c(1:4), labels=c("First Year", "Second Year","Third Year", "Fourth Year"))) %>% 
  au_maps()
dev.off()

# Produce GA Maps ----
pdf("GA Maps.pdf", width=27.5, height=21.25)
ga_maps(m.map)
dev.off()

# Produce UDLE Maps ----
pdf("UDLE Maps.pdf", width=27.5, height=21.25)
udle_maps(m.map)
dev.off()


# Big Joint Map ----
au.data <- masters %>%
  filter(`Academic year` == "2015-2016") %>% 
  inner_join(mech.program %>% 
               filter(Option == "CORE" | Option == "ME1"), by="Course Code") %>% 
  mutate(Year = factor(Year, levels=c(1:4), labels=c("First Year", "Second Year","Third Year", "Fourth Year")))

pdf("Joint Maps.pdf", width=55, height=42.5)
joint_maps(au.data,m.map)
dev.off()

# Joining Attributes and AUs
map_data <- m.mech %>%
  filter(academic_year == "2014-2015") %>%
  distinct(assessment, attribute, indicator, context) %>%
  group_by(indicator, attribute, course_code) %>%
  tally %>%
  arrange(attribute) %>%
  left_join(
    masters %>%
      filter(
        `Academic year` == "2014-2015", Department == "MECH" |
          Department == "APSC"
      ) %>%
      select(`COURSE CODE`, Math:ED) %>%
      dplyr::rename(course_code = `COURSE CODE`
      )) %>% 
  gather(AU,Value,Math:ED) %>% 
  left_join(attribute.colors) %>% 
  left_join(au.colors)



