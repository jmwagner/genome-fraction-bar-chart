#!/usr/bin/Rscript

library(plyr)
library(ggplot2)
library(plotly)

args = commandArgs(trailingOnly=TRUE)

#path to commits_info.tsv file
path = args[1] 

#path to file in metaquast output folder
postfix = args[2]

inputDataframe = cbind.data.frame(read.delim(path, header = TRUE, stringsAsFactors = FALSE))
inputDataframe$path <- file.path(inputDataframe$path, postfix)

#iterate over all assembly results and combine all quast results (transposed_report.tsv)
fillDataset <- function(paths) {
   for (file in paths) {
            print(file)
            if (!exists("dataset")) {
       		dataset <- cbind.data.frame(read.delim(file, header=TRUE, stringsAsFactors=FALSE))
	        dataset$path = file
            } else {
              temp_dataset <- cbind.data.frame(read.delim(file, header=TRUE, stringsAsFactors=FALSE))
              temp_dataset$path = file
              dataset <- rbind.fill(list(dataset, temp_dataset))
            }
  }
  dataset <- dataset[!grepl("broken", dataset$Assembly),]
  dataset
}

#merge the dataframe
total <- merge(inputDataframe, fillDataset(inputDataframe$path), by = c("path"))

#build the plot with ggplot
p <- ggplot(data=total, aes(x=reorder(name, Genome.fraction....), y=Genome.fraction...., fill=name) ) + 
	geom_bar(stat="identity") + 
	coord_flip() +
	labs(x = "Assemblers",
	    y = "Genome Fraction (%)",
	    fill = "Assemblers")

pl <- ggplotly(p)

#write html file to output and copy bioboxes.yaml that descibes the produced out.html file
htmlwidgets::saveWidget(pl,'/output/out.html')
system("cp /project/biobox.yaml /output")
