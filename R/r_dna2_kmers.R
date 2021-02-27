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

# kmer counting
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
# Ir'a ~50:50? Typical for E. coli: http://dro.deakin.edu.au/eserv/DU:30034416/chen-bacterialgenomic-2010.pdf




kmers = oligonucleotideFrequency(genome, width = 9)
kmers = as.data.frame(kmers)
longkmers = tidyr::pivot_longer(kmers, cols=names(kmers))
longkmers$value = as.numeric(longkmers$value)

ggplot(longkmers) + 
  geom_col(aes(x=reorder(name, value), y=value)) +
  theme(axis.text.x = element_text(angle=90)) 
     