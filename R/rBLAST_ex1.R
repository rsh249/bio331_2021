# rBLAST example
#install.packages('devtools')
#devtools::install_github("mhahsler/rBLAST")
library(rBLAST)
library(ggplot2)

download.file('ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Vibrio_cholerae/representative/GCF_000829215.1_ASM82921v1/GCF_000829215.1_ASM82921v1_genomic.fna.gz',
              'cholera.fna.gz')
system('gunzip cholera.fna.gz')
genome = readDNAStringSet('cholera.fna')

download.file('https://raw.githubusercontent.com/developing-bioinformatics/bioinformatics/master/data/ctxAB.fasta',
              'ctxAB.fasta')
query = readDNAStringSet('ctxAB.fasta')


reference = 'cholera.fna'


makeblastdb(reference, dbtype='nucl')

# setup blast query
bl <- blast(db=reference, type='blastn')
cl <- predict(bl, query)

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
               n=4600) +
  xlim(0, 2936971)


