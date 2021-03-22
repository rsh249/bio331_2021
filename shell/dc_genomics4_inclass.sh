# working with SAM (BAM, BCF, and VCF) files

SRA=SRR2584863

# convert SAM to BAM
samtools view -S -b results_process/sam/$SRA.sam > results_process/bam/$SRA.bam

# sort bam file (by genomic coordinates)
samtools sort -o results_process/bam/$SRA.aligned.sorted.bam results_process/bam/$SRA.bam

# check out our alignment
samtools flagstat results_process/bam/$SRA.aligned.sorted.bam


# variant calling --> What is the concensus sequence at each position and is it different from the genome
bcftools mpileup --output-type b --output results_process/vcf/$SRA\_raw.bcf \
  -f data_process/ecoli_rel606.fasta results_process/bam/$SRA.aligned.sorted.bam
  
bcftools call --ploidy 1 -m -v -o results_process/vcf/$SRA\_variants.vcf results_process/vcf/$SRA\_raw.bcf

vcfutils.pl varFilter results_process/vcf/$SRA\_variants.vcf > results_process/vcf/$SRA\_final_variants.vcf

  
  
  