library(ShortRead)
library(Biostrings)
library(ggplot2)

#read fastq data
fq <- readFastq('SRR13764788.fastq')
head(fq)

#reads <- readDNAStringSet('SRR13764788.fastq', format='fastq')
reads = sread(fq)

# use Biostrings to count nucleotide frequency
alphabetFrequency(reads, as.prob=T)
nucl.freq = alphabetFrequency(reads, as.prob=T)[,1:4]
nucl.freq = as.data.frame(nucl.freq)
nucl.freq$AT = nucl.freq$A + nucl.freq$T
nucl.freq$GC = nucl.freq$G + nucl.freq$C

#dip into a little tidyr to reorganize the data frame to work better with ggplot
GC.freq = tidyr::pivot_longer(nucl.freq[,c("AT", "GC")], cols=c("AT", "GC"))

ggplot(GC.freq) +
  geom_histogram(aes(x=value, fill=name), position='identity', alpha=0.7, bins=90) +
  scale_fill_manual(values=c('steelblue', 'darkorange')) +
  theme_minimal()

# explore a genome
# get a genome:
download.file('ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Escherichia_coli/reference/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz',
              'genome.fna.gz')
genome = readDNAStringSet('genome.fna.gz')
nchar(genome)

#gc
geno.freq = alphabetFrequency(genome, as.prob=T)[,1:4]
geno.f = data.frame(GC=numeric(), AT=)
geno.freq[[1]] + geno.freq[[4]]
geno.freq[[2]] + geno.freq[[3]]
# ~50:50? Typical for E. coli: http://dro.deakin.edu.au/eserv/DU:30034416/chen-bacterialgenomic-2010.pdf

slidingGC = letterFrequencyInSlidingView(genome[[1]], 
                                         view.width=100000,
                                         letters=c("C", "G"), 
                                         as.prob = T)
slidingGC = as.data.frame(slidingGC)
slidingGC$ratio = slidingGC$G - slidingGC$C
slidingGC$position = 1:nrow(slidingGC)

#sample to 100,000 nucleotide bins
sampleGC = slidingGC[seq(1, nrow(slidingGC), by=100000),]

ggplot(sampleGC) +
  geom_path(aes(x = position, y = ratio)) +
  theme_minimal() 

# where does the ratio go from neg to pos?
print(sampleGC)
# search kmers here: 370000 to 380000

#trim genome 
target_area = genome[[1]][370000:380000] #use string index

kmers = oligonucleotideFrequency(target_area, width = 9)
kmers = as.data.frame(kmers)
kmers$count = as.numeric(kmers$kmers)
found = kmers[kmers$kmers>=3,]
found$kmers = rownames(found)

ggplot(found) +
  geom_col(aes(x=kmers, y=count)) +
  theme(axis.text.x = element_text(angle=90))
