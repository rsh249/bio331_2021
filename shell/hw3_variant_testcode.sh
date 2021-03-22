# get fastq data
#pick an SRA file from: https://www.ncbi.nlm.nih.gov/sra

SRA=SRR13997291
mkdir data
mkdir results
fasterq-dump -e 2 --split-files -O data $SRA

fastqc -t 2 -o results data/*.fastq

trimmomatic PE -threads 2 data/$SRA\_1.fastq data/$SRA\_2.fastq \
  data/$SRA\_1.trim.fastq data/$SRA\_2.trim.fastq \
  data/$SRA\_1.untrim.fastq data/$SRA\_2.untrim.fastq \
  SLIDINGWINDOW:4:20 MINLEN:25 

# get reference genome 
# all are made to the Wuhan-Hu1 genome
curl -o "Wuhan-Hu1.fasta" "https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=1798174254&extrafeat=null&conwithfeat=on&hide-cdd=on"

bwa index Wuhan-Hu1.fasta 


# align reads 
mkdir results/sam
mkdir results/bam
mkdir results/bcf
mkdir results/vcf
bwa mem -t 2 Wuhan-Hu1.fasta data/$SRA\_1.trim.fastq > results/sam/$SRA.aligned.sam

samtools view -S -b results/sam/$SRA.aligned.sam > results/bam/$SRA.aligned.bam
samtools sort -o results/bam/$SRA.aligned.sorted.bam results/bam/$SRA.aligned.bam 
samtools flagstat results/bam/$SRA.aligned.sorted.bam



bcftools mpileup -O b -o results/bcf/$SRA\_raw.bcf \
  -f Wuhan-Hu1.fasta results/bam/$SRA.aligned.sorted.bam 
  
bcftools call --ploidy 1 -m -v -o results/bcf/$SRA\_variants.vcf results/bcf/$SRA\_raw.bcf 


vcfutils.pl varFilter results/bcf/$SRA\_variants.vcf  > results/vcf/$SRA\_final_variants.vcf

samtools index results/bam/$SRA.aligned.sorted.bam
samtools tview results/bam/$SRA.aligned.sorted.bam Wuhan-Hu1.fasta

