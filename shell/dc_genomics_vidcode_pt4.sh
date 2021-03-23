# convert SAM to VCF and visualize

# Set variable for SRA ID numbers:
#SRA=SRR2584863

# declare an array of SRA values

declare -a sra=("SRR2584863" "SRR2584866" "SRR2589044")


for SRA in "${sra[@]}"
do
##samtools
# convert SAM to BAM
samtools view -S -b results_process/sam/$SRA.sam > results_process/bam/$SRA.bam

# sort the bam file (by genomic coordinates)
samtools sort -o results_process/bam/$SRA.aligned.sorted.bam results_process/bam/$SRA.bam

# check alignment stats: flagstat
samtools flagstat results_process/bam/$SRA.aligned.sorted.bam

##bcftools
# mpilup: calculate coverage
bcftools mpileup --output-type b --output results_process/vcf/$SRA\_raw.bcf \
  -f data_process/ecoli_rel606.fasta results_process/bam/$SRA.aligned.sorted.bam
  
  
# call: call variants
bcftools call --ploidy 1 -m -v -o results_process/vcf/$SRA\_variants.vcf results_process/vcf/$SRA\_raw.bcf

# vcfutils: filter variants
vcfutils.pl varFilter results_process/vcf/$SRA\_variants.vcf > results_process/vcf/$SRA\_final_variants.vcf
done
