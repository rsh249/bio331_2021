mkdir data
mnkdir results
SRA=SRR14023788
fasterq-dump -e 2 --split-files -O data $SRA

fastqc data/$SRA*.fastq #run fastqc

# trimmomatic


#bwa index reference
curl -o 'Wuhan-Hu1.fasta' 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=1798174254&extrafeat=null&conwithfeat=on&hide-cdd=on'

#bwa mem: align reads to reference

# samtools and bcftools convert sam to bam to vcf

