# read DNA sequence data into R with Bioconductor and visualize

library(ShortRead)
library(ggplot2)
library(fastqq)

# run on terminal
# module load sratoolkit
# fastq-dump SRR13764788

fq = readFastq('SRR13764788.fastq')

summary(fq)
class(fq)


sread(fq)
id(fq)

quality(fq)

reads = sread(fq)
reads[1] #view read 1
as.character(reads[1]) # read 1 as plain text

widths = as.data.frame(reads@ranges@width)

# vis read lengths
ggplot(widths) + 
  geom_histogram(aes(x=reads@ranges@width)) 

# quality scores
qual = quality(fq)
numqscores = as(qual, "matrix") # converts to numeric scores automatically
avgscores = rowMeans(numqscores, na.rm=T) 
avgscores = as.data.frame(avgscores)
ggplot(avgscores) + 
  geom_histogram(aes(x=avgscores))

# GC content
alphabetFrequency(reads)[,1:4] # BioStrings count letter frequencies

