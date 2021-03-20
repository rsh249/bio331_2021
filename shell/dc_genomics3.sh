# alignment phase

# get reference genome
cd data_process
curl -L -o ecoli_rel606.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz
gunzip ecoli_rel606.fasta.gz


cd ..

mkdir results_process
mkdir -p results_process/sam results_process/bam results_process/vcf

# index the reference genome
#run from dc_workshop folder so you can view data_process and results_process as relative paths.

bwa index data_process/ecoli_rel606.fasta

# ALign reads
bwa mem data_process/ecoli_rel606.fasta \
  data_process/SRR2584863_1.trim.fastq data_process/SRR2584863_2.trim.fastq \
  > results_process/sam/SRR2584863.sam
  
head results_process/sam/SRR2584863.sam

# set up for next two samples
for infile in *_1.fastq
do
  base=$(basename ${infile} _1.fastq)
  trimmomatic PE -threads 4 data_process/${base}_1.fastq data_process/${base}_2.fastq \
    data_process/${base}_1.trim.fastq data_process/${base}_1.untrim.fastq \
    data_process/${base}_2.trim.fastq data_process/${base}_2.untrim.fastq \
    SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15
    
  bwa mem data_process/ecoli_rel606.fasta \
    data_process/${base}_1.trim.fastq data_process/${base}_1.trim.fastq \
    > results_process/sam/${base}.sam0
done






  
  


