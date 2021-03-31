# Using data from the NCBI SARS-CoV-2 data: https://www.ncbi.nlm.nih.gov/sars-cov-2/
# get reference genome 
# all are made to the Wuhan-Hu1 genome
curl -o "Wuhan-Hu1.fasta" "https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=1798174254&extrafeat=null&conwithfeat=on&hide-cdd=on"
# get annotation track (for later)
curl -o "Wuhan-Hu1.genomic.gff.gz" "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/858/895/GCF_009858895.2_ASM985889v3/GCF_009858895.2_ASM985889v3_genomic.gff.gz"
gunzip "Wuhan-Hu1.genomic.gff.gz"

#index the genome
bwa index Wuhan-Hu1.fasta 


# align reads 
mkdir results
mkdir results/sam
mkdir results/bam
mkdir results/vcf
mkdir data

# get fastq data
#pick a sample of 10 SRA file from: 
#SRA=SRR13997291

declare -a sra=("ERR4388072")


for SRA in "${sra[@]}"
do
  fasterq-dump -e 2 --split-files -O data $SRA

  fastqc -t 2 -o results data/$SRA\_1.fastq data/$SRA\_2.fastq

  # trim on quality (no adapters present)
  trimmomatic PE -threads 2 data/$SRA\_1.fastq data/$SRA\_2.fastq \
    data/$SRA\_1.trim.fastq data/$SRA\_2.trim.fastq \
    data/$SRA\_1.untrim.fastq data/$SRA\_2.untrim.fastq \
    SLIDINGWINDOW:4:20 MINLEN:25 

  bwa mem -t 2 Wuhan-Hu1.fasta data/$SRA\_1.trim.fastq > results/sam/$SRA.aligned.sam

  samtools view -S -b results/sam/$SRA.aligned.sam > results/bam/$SRA.aligned.bam
  samtools sort -o results/bam/$SRA.aligned.sorted.bam results/bam/$SRA.aligned.bam 
  samtools flagstat results/bam/$SRA.aligned.sorted.bam
  bcftools mpileup -O b -o results/vcf/$SRA\_raw.bcf \
    -f Wuhan-Hu1.fasta results/bam/$SRA.aligned.sorted.bam 
  bcftools call --ploidy 1 -m -v -o results/vcf/$SRA\_variants.vcf results/vcf/$SRA\_raw.bcf 
  vcfutils.pl varFilter results/vcf/$SRA\_variants.vcf  > results/vcf/$SRA\_final_variants.vcf
done
