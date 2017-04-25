#!/usr/bin/Rscript

library(plyr)
library(ggplot2)
library(plotly)

args = commandArgs(trailingOnly=TRUE)
path = args[1] 
postfix = args[2]

inputDataframe = cbind.data.frame(read.delim(path, header = TRUE, stringsAsFactors =
                                               FALSE))
inputDataframe$path <- file.path(inputDataframe$path, postfix)


fillDataset <- function(paths) {
   for (file in paths) {
            if (!exists("dataset")) {
	        print(file)
       		dataset <- cbind.data.frame(read.delim(file, header=TRUE, stringsAsFactors=FALSE))
	        dataset <- dataset[!grepl("broken", dataset$Assembly),]
	        dataset$path = file
            } else {
              print(file)
              temp_dataset <- cbind.data.frame(read.delim(file, header=TRUE, stringsAsFactors=FALSE))
              temp_dataset$path = file
              temp_dataset <- temp_dataset[!grepl("broken", temp_dataset$Assembly),]
              dataset <- rbind.fill(list(dataset, temp_dataset))
              rm(temp_dataset)
            }
  }
  dataset
}

total <- merge(inputDataframe, fillDataset(inputDataframe$path), by = c("path"))
total[is.na(total)] <- 0
total$Genome.fraction.... <- factor(total$Genome.fraction...., levels=sort(total$Genome.fraction....,  decreasing=TRUE))

p <- ggplot(data=total, aes(x=name, y=Genome.fraction...., fill=name)) +    geom_bar(stat="identity") + coord_flip()
pl <- ggplotly(p)

htmlwidgets::saveWidget(pl,'/output/out.html')
system("cp /project/biobox.yaml /output")
