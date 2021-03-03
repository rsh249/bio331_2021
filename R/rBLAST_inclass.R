# rBLAST example
#install.packages('devtools')
#devtools::install_github("mhahsler/rBLAST")
library(rBLAST)
library(ggplot2)

# read in query data
fq <- readDNAStringSet('SRR13764788.fastq', format='fastq')
head(fq)

# reference data
system('gunzip genome.fna.gz') # run a shell command 'gunzip'
genome = readDNAStringSet('genome.fna', format='fasta')

# setting up BLAST database
reference = 'genome.fna'
makeblastdb(reference, dbtype='nucl')

# query data
print(fq)
dna = fq
#quality control
geno.freq = as.data.frame(alphabetFrequency(dna))
geno.freq[geno.freq$N>0,] #view the alphabetFrequency of reads containing N
dna_filter <- dna[geno.freq$N==0] # filter the dna query for reads with NO 'N'

# setup blast query
bl <- blast(db=reference, type='blastn')
cl <- predict(bl, dna_filter, BLAST_args="-max_target_seqs 1")

# plotting
ggplot(cl) +
  geom_histogram(aes(x=Perc.Ident)) +
  theme_minimal()

ggplot(cl) +
  geom_histogram(aes(x=Alignment.Length)) +
  theme_minimal()

# plot where these matches are
ggplot(cl) +
  geom_density(aes(x=S.start),
               kernel='rectangular',
               n=4600)
