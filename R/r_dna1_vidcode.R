library(ShortRead)
library(ggplot2)

# SRA Toolkit
# fastq-dump SRR13764788
# wrote SRR13764788.fastq

# read fastq
fq = readFastq('SRR13764788.fastq')

# look at DNA sequences
reads = sread(fq)
widths = as.data.frame(reads@ranges@width)

ggplot(widths) + 
  geom_histogram(aes(x=reads@ranges@width))

# graph the quality scores
quals = quality(fq)
numqscores = as(quals, 'matrix')
avgscore = rowMeans(numqscores, na.rm = T)
avgscore = as.data.frame(avgscore)

ggplot(avgscore) + 
  geom_histogram(aes(x=avgscore))
