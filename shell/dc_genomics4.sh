# dc genomics
# variant calling from aligned (SAM) files
# for: SRR2584863.sam  SRR2584866.sam  SRR2589044.sam
## declare an array variable
declare -a sra=("SRR2584863" "SRR2584866" "SRR2589044")

## now loop through the above array
for SRA in "${sra[@]}"
do
  echo $SRA
  samtools view -S -b results_process/sam/$SRA.sam > results_process/bam/$SRA.aligned.bam
  samtools sort -o results_process/bam/$SRA.aligned.sorted.bam results_process/bam/$SRA.aligned.bam 
  samtools flagstat results_process/bam/$SRA.aligned.sorted.bam



  bcftools mpileup -O b -o results_process/vcf/$SRA\_raw.bcf \
    -f ecoli_rel606.fasta results_process/bam/$SRA.aligned.sorted.bam 
  
  bcftools call --ploidy 1 -m -v -o results_process/vcf/$SRA\_variants.vcf results_process/vcf/$SRA\_raw.bcf 


  vcfutils.pl varFilter results_process/vcf/$SRA\_variants.vcf  > results_process/vcf/$SRA\_final_variants.vcf

  samtools index results_process/bam/$SRA.aligned.sorted.bam
  #samtools tview results_process/bam/$SRA.aligned.sorted.bam ecoli_rel606.fasta
done
