# dc genomics
# variant calling from aligned (SAM) files
# for: SRR2584863.sam  SRR2584866.sam  SRR2589044.sam
## declare an array variable
declare -a sra=("SRR2584863" "SRR2584866" "SRR2589044")

## now loop through the above array
for SRA in "${sra[@]}"
do
  echo $SRA
<<<<<<< HEAD
  #convert to BAM
  samtools view -S -b results_process/sam/$SRA.sam > results_process/bam/$SRA.aligned.bam
  #sort
  samtools sort -o results_process/bam/$SRA.aligned.sorted.bam results_process/bam/$SRA.aligned.bam 
  #view alignment stats
  samtools flagstat results_process/bam/$SRA.aligned.sorted.bam
  
  #convert to bcf -- > summarize alignments
  bcftools mpileup -O b -o results_process/vcf/$SRA\_raw.bcf \
    -f ecoli_rel606.fasta results_process/bam/$SRA.aligned.sorted.bam 
  
  #call variants to vcf
  bcftools call --ploidy 1 -m -v -o results_process/vcf/$SRA\_variants.vcf results_process/vcf/$SRA\_raw.bcf 
  
  #filter
  vcfutils.pl varFilter results_process/vcf/$SRA\_variants.vcf  > results_process/vcf/$SRA\_final_variants.vcf
  #index (not critical for IGV pipeline)
  samtools index results_process/bam/$SRA.aligned.sorted.bam
  #samtools tview results_process/bam/$SRA.aligned.sorted.bam ecoli_rel606.fasta
done


# view vcf files in igv
=======
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
>>>>>>> 27150d889f41ccff2612e730a34027adce2b1004
