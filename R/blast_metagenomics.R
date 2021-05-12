library(rBLAST)
library(ggplot2)
library(parallel)
library(taxonomizr) # install.packages('taxonomizr') #run if not already installed
library(forcats)


# set up a new working directory
dir.create('metagenomics')
setwd('metagenomics')

# from: ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral
dir.create('ref')
download.file('ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.1.1.genomic.fna.gz', 'ref/viral.1.1.genomic.fna.gz')
download.file('ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.2.1.genomic.fna.gz', 'ref/viral.2.1.genomic.fna.gz')
download.file('ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.3.1.genomic.fna.gz', 'ref/viral.3.1.genomic.fna.gz')

# unzip and put all of the viral reference files into one:
system("gunzip ref/*")
system("cat ref/*.fna > ref/viral_all.fasta")


# get our unknown fastq data
dir.create('data')
options(timeout=9999) # set a higher timeout for larger downloads
download.file('https://sra-pub-sars-cov2.s3.amazonaws.com/sra-src/SRR11092062/v300043428_L02_127_1.fq.gz', 'data/viral_metagenome.fq.gz', extra = 'curl')
system('gunzip data/viral_metagenome.fq.gz')


# check for files we need
list.files(recursive = T)


##### BLAST #####
# read in the query data as a DNAStringSet
fq <- readDNAStringSet('data/viral_metagenome.fq',format = 'fastq')
head(fq)

#make a new blast database to search
reference = 'ref/viral_all.fasta'
makeblastdb(reference, dbtype = "nucl")

# search the database
#prepare
bl <- blast(db=reference, type='blastn')

##### PARALLEL COMPUTING WITH BLAST #####
#run parallel blast searches

# an R function to run the blast query
parpredict = function(x){
  return(predict(bl, x))
}
clus = makeCluster('16', type ='FORK');
splits = clusterSplit(clus, fq)
p_cl = parLapply(clus, splits, parpredict)
stopCluster(clus)
cl = dplyr::bind_rows(p_cl)
##### END PARALLEL COMPUTING ##### 

# set up access to taxonomizr database
tax_db = '/projectnb/ct-shbioinf/bio331/db/taxonomy' 
tax_db_files = list.files(tax_db, full.names = TRUE)
nodes = tax_db_files[grepl('nodes', tax_db_files)]
names = tax_db_files[grepl('names', tax_db_files)]
accession = tax_db_files[grepl('accessionTaxa', tax_db_files)]
taxaNodes<-read.nodes.sql(nodes)
taxaNames<-read.names.sql(names)

# get data for BLAST hit accession numbers
accid = as.character(cl$SubjectID) # accession IDs of BLAST hits
#takes accession number and gets the taxonomic ID
ids<-accessionToTaxa(accid, accession)
#taxlist displays the taxonomic names from each ID #
taxlist=getTaxonomy(ids, taxaNodes, taxaNames)
cltax=cbind(cl,taxlist)


#filter and visualize results

summary(cltax)
cltax95 <- cltax[which(cltax$Perc.Ident>95 & cltax$Alignment.Length>140),]
unique(cltax95$family)
ggplot(cltax95) +
  geom_bar(aes(x=fct_infreq(family))) +
  theme(axis.text.x = element_text(angle = 90))

ggplot(cltax95) +
  geom_bar(aes(x=fct_infreq(species))) +
  theme(axis.text.x = element_text(angle = 90))

