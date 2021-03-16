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

# watch for ambiguous base calls 

# setting up BLAST
reference = 'cholera.fna'

makeblastdb(reference, dbtype='nucl')

# run BLAST query
bl <- blast(db=reference, type='blastn')
cl <- predict(bl, query)

ggplot(cl) +
  geom_density(aes(x=S.start), kernel='rectangular', n=3000) +
  xlim(0, 2936971) + 
  theme_linedraw()



