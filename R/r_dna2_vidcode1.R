library(BioStrings) # read and manipulate DNA data
library(ggplot2) #data vis

download.file('ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Escherichia_coli/reference/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz',
              'genome.fna.gz')

genome = readDNAStringSet('genome.fna.gz')


# BioStrings functions
# alphabetFrequency() # calculate the frequency of nucleotides
alphabetFrequency(genome)
geno.freq = alphabetFrequency(genome, as.prob=T)
barplot(geno.freq[,1:4])
geno.freq[[2]] + geno.freq[[3]]

# search for DNA word
# countPattern and matchPattern
p1 <- "ATG"
p2 <- "TAC"

countPattern(p1, genome[[1]])
countPattern(p2, genome[[1]])

m1 = matchPattern(p1, genome[[1]])
m2 = matchPattern(p2, genome[[1]])

matchdf1 = as.data.frame(m1@ranges)
matchdf2 = as.data.frame(m2@ranges)

ggplot() +
  geom_density(data=matchdf1, aes(x=start), col='darkorange', kernel='rectangular', n=4600) +
  geom_density(data=matchdf2, aes(x=start), col='steelblue', kernel='rectangular', n=4600) +
  theme_minimal()
