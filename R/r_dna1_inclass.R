library(ShortRead)
library(ggplot2)

#read fastq data
fq <- readFastq('SRR13764788.fastq')
head(fq)

# what if we the DNA sequences?
reads <- sread(fq)
print(reads)

# what if we want to view the quality scores?
qual = quality(fq)
head(qual)
numqscores = as(qual, "matrix") 
#calculate average quality score for reads
avgscores = rowMeans(numqscores, na.rm = T)
head(avgscores)
avgscores = as.data.frame(avgscores)
ggplot(avgscores) + 
  geom_histogram(aes(x=avgscores))
