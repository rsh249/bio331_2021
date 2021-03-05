library(Biostrings)
library(ggplot2)

download.file('ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Vibrio_cholerae/representative/GCF_000829215.1_ASM82921v1/GCF_000829215.1_ASM82921v1_genomic.fna.gz',
              'cholera.fna.gz')
genome = readDNAStringSet('cholera.fna.gz')

#next line does not work. Fix it?
ifelse(length(genome)>1, alphabetFrequency(genome, as.prob=T)[,1:4], alphabetFrequency(genome, as.prob=T)[1:4])

if(length(genome)>1) {
  alphabetFrequency(genome, as.prob=T)[,1:4]
} else {
  alphabetFrequency(genome, as.prob=T)[1:4]
}

slidingGC = letterFrequencyInSlidingView(genome[[1]], 
                                         view.width=100000,
                                         letters=c("C", "G"), 
                                         as.prob = T)
