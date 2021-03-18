mkdir data_process
cd data_process

cp ../data/untrimmed_fastq/*.fastq ./

trimmomatic PE SRR2584863_1.fastq SRR2584863_2.fastq \
  SRR2584863_1.trim.fastq SRR2584863_1.untrim.fastq \
  SRR2584863_2.trim.fastq SRR2584863_2.untrim.fastq \
  SLIDINGWINDOW:4:20 MINLEN:25
  
wget https://raw.githubusercontent.com/timflutre/trimmomatic/master/adapters/NexteraPE-PE.fa

trimmomatic PE SRR2584863_1.fastq SRR2584863_2.fastq \
  SRR2584863_1.trim.fastq SRR2584863_1.untrim.fastq \
  SRR2584863_2.trim.fastq SRR2584863_2.untrim.fastq \
  SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15
  
# automate with a loop
for infile in *_1.fastq
do
  base=$(basename ${infile} _1.fastq)
  trimmomatic PE -threads 4 ${base}_1.fastq ${base}_2.fastq \
    ${base}_1.trim.fastq ${base}_1.untrim.fastq \
    ${base}_2.trim.fastq ${base}_2.untrim.fastq \
    SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15
done


