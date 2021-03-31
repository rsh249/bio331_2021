library(Biostrings)
library(ggplot2)
setwd('genome_assembly')
contigs = readDNAStringSet('dirVelvet/contigs.fa')
contigs
max(contigs@ranges@width) #what is the longest contig?

contigs[which(contigs@ranges@width >= 2000)]
as.character(contigs[which(contigs@ranges@width >= 3000)])

Mcontigs = readDNAStringSet('dirMEGAHIT/final.contigs.fa')
maxMcontigs = max(Mcontigs@ranges@width)
as.character(Mcontigs[which(Mcontigs@ranges@width == maxMcontigs)])
