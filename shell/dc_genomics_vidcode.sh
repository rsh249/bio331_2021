mkdir -p ~/dc_workshop/data/untrimmed_fastq/
cd ~/dc_workshop/data/untrimmed_fastq

curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/SRR2589044/SRR2589044_1.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/SRR2589044/SRR2589044_2.fastq.gz

curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/003/SRR2584863/SRR2584863_1.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/003/SRR2584863/SRR2584863_2.fastq.gz

curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2584866/SRR2584866_1.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2584866/SRR2584866_2.fastq.gz 

gunzip *.fastq.gz # unzip all fastq.gz files one at a time 

# command line fastq quality control
fastqc -h

mkdir results

fastqc -t 2 -o results data/untrimmed_fastq/*.fastq
ls results

mkdir data_RH
cd data_RH
cp ../data/untrimmed_fastq/*.fastq ./

#paired End
trimmomatic PE SRR2584863_1.fastq SRR2584863_2.fastq \
  SRR2584863_1.trim.fastq SRR2584863_1.untrim.fastq \
  SRR2584863_2.trim.fastq SRR2584863_2.untrim.fastq \
  SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:../data/NexteraPE-PE.fa:2:40:15
  
trimmomatic PE SRR2584866_1.fastq SRR2584866_2.fastq \
  SRR2584866_1.trim.fastq SRR2584866_1.untrim.fastq \
  SRR2584866_2.trim.fastq SRR2584866_2.untrim.fastq \
  SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:../data/NexteraPE-PE.fa:2:40:15
  
trimmomatic PE SRR2589044_1.fastq SRR2589044_2.fastq \
  SRR2589044_1.trim.fastq SRR2589044_1.untrim.fastq \
  SRR2589044_2.trim.fastq SRR2589044_2.untrim.fastq \
  SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:../data/NexteraPE-PE.fa:2:40:15
  
# for loop for repeating actions **
for infile in *_1.fastq
do
  base=$(basename ${infile} _1.fastq)
  trimmomatic PE ${base}_1.fastq ${base}_2.fastq \
    ${base}_1.trim.fastq ${base}_1.untrim.fastq \
    ${base}_2.trim.fastq ${base}_2.untrim.fastq \
    SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:../data/NexteraPE-PE.fa:2:40:15 &
done

# maybe use xargs


  







