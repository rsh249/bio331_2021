# alignment phase

# get reference genome
cd data_process
curl -L -o ecoli_rel606.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz
gunzip ecoli_rel606.fasta.gz

mkdir -p results_process/sam results_process/bam results_process/vcf

# index the reference genome
bwa index data_process/ecoli_rel606.fasta

# ALign reads
bwa mem data_process/ecoli_rel606.fasta \
  data_process/SRR2584863_1.trim.fastq data_process/SRR2584863_2.trim.fastq \
  > results_process/sam/SRR2584863.sam
  
head results_process/sam/SRR2584863.sam

# set up for next two samples







  
  


