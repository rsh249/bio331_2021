library(Biostrings)
library(ggplot2)
# get an E. coli genome from NCBI genomes FTP service
download.file('ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Escherichia_coli/reference/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz',
              'genome.fna.gz')

genome = readDNAStringSet('genome.fna.gz')
print(genome) # view genome object

nchar(genome) # length of the genome

genome[[1]]
genome[[1]][4600000:4600100]

# nucleotide frequencies
geno.freq = alphabetFrequency(genome, as.prob = T)[,1:4]
barplot(geno.freq)

geno.freq[[2]] + geno.freq[[3]]

# search for a particular DNA "word"
p1 <- "ATG"
p2 <- "CAT"

count1 = countPattern(p1, genome[[1]])
count2 = countPattern(p2, genome[[1]])
count1 + count2

match1 = matchPattern(p1, genome[[1]])
match2 = matchPattern(p2, genome[[1]])
matchdf1 = as.data.frame(match1@ranges)
matchdf2 = as.data.frame(match2@ranges)
ggplot() +
  geom_density(data=matchdf1, aes(x=start), col='darkorange') +
  geom_density(data=matchdf2, aes(x=start), col='steelblue')


# calculate letter frequency in a sliding window
slidingGC = letterFrequencyInSlidingView(genome[[1]],
                                         view.width = 100000,
                                         letters = c("C", "G"),
                                         as.prob = T)
slidingGC = as.data.frame(slidingGC)
# compute G - C
slidingGC$ratio = slidingGC$G - slidingGC$C
slidingGC$position = 1:nrow(slidingGC)

sampleGC = slidingGC[seq(1, nrow(slidingGC), by = 100000),]

ggplot(sampleGC) + 
  geom_path(aes(x=position, y=ratio))
