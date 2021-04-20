library(rBLAST)
library(taxonomizr)
library(parallel)
library(ggplot2)
library(forcats)

# set up workspace
dir.create('metagenomics')
setwd('metagenomics')

# ref
dir.create('ref')
download.file('ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.1.1.genomic.fna.gz', 'ref/viral.1.1.genomic.fna.gz')
download.file('ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.2.1.genomic.fna.gz', 'ref/viral.2.1.genomic.fna.gz')
download.file('ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.3.1.genomic.fna.gz', 'ref/viral.3.1.genomic.fna.gz')
system("gunzip ref/*")
system("cat ref/*.fna > ref/viral_all.fasta")

# raw data
dir.create('data')
options(timeout=9999) # set a higher timeout for larger downloads
download.file('https://sra-pub-sars-cov2.s3.amazonaws.com/sra-src/SRR11092062/v300043428_L02_127_1.fq.gz', 'data/viral_metagenome.fq.gz', extra = 'curl')
system('gunzip data/viral_metagenome.fq.gz')


# read query data
fq <- readDNAStringSet('data/viral_metagenome.fq', format = 'fastq')

# set up a BLAST database with viral refseq
reference <- 'ref/viral_all.fasta'
makeblastdb(reference, dbtype='nucl')
bl <- blast(db=reference, type='blastn')

##### BLAST in parallel #####
parpredict <- function(x){
  return(predict(bl, x))
}

# set up a cluster
clus <- makeCluster('16', type='FORK')
splits <- clusterSplit(clus, fq)
p_cl <- parLapply(clus, splits, parpredict)
stopCluster(clus)

cl <- dplyr::bind_rows(p_cl)

#### END PARALLEL #####


summary(cl)

# a bit of filtering
clfilt <- cl[which(cl$Perc.Ident>=95 & cl$Alignment.Length>=140),]


# TAXONOMY #
# dir.create('taxonomy')
# prepareDatabase('taxonomy/accessionTaxa.sql')

tax_db = '../db/taxonomy/'
tax_db_files = list.files(tax_db, full.names = TRUE)
nodes = tax_db_files[grepl('nodes', tax_db_files)]
names = tax_db_files[grepl('names', tax_db_files)]
accession = tax_db_files[grepl('accessionTaxa', tax_db_files)]
taxaNodes<-read.nodes.sql(nodes)
taxaNames<-read.names.sql(names)

# search for blast hit accession IDs
accid = as.character(clfilt$SubjectID) # accession IDs of BLAST hits

#takes accession number and gets the taxonomic ID
ids<-accessionToTaxa(accid, accession)

#taxlist displays the taxonomic names from each ID #
taxlist=getTaxonomy(ids, taxaNodes, taxaNames)
cltax=cbind(clfilt,taxlist)

## visualize
ggplot(cltax) +
  geom_bar(aes(x=fct_infreq(family))) +
  theme(axis.text.x = element_text(angle=90))

ggplot(cltax) +
  geom_bar(aes(x=fct_infreq(species))) +
  theme(axis.text.x = element_text(angle=90))
