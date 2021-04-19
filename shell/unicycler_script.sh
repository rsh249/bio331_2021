#!/usr/bin/bash
# Your Name (2021)
# add info about running the script
# programs required

mkdir hybrid_assemble
cd hybrid_assemble

mkdir data
#set number of threads to use for parallelization
nthreads=16
#set variables pointing to the SRA run ID for 
#nanopore data
nanoraw="SRR5665597"
#illumina short read data
shortraw="ERR1023775"

fasterq-dump -e $nthreads -O data $nanoraw
fasterq-dump -e $nthreads --split-files -O data $shortraw

fastqc -t $nthreads data/$shortraw* 
fastqc -t $nthreads --nano data/$nanoraw*

## run unicycler
conda activate py368
module load samtools
#put your unicyler commands here
# illumina only
unicycler  -1 data/$shortraw\_1.fastq -2 data/$shortraw\_2.fastq -o unicycler_short --threads $nthreads

# nanopore long read only
unicycler -l data/$nanoraw.fastq -o unicycler_long --threads $nthreads

# hybrid assembly: both illumina and nanopore data
unicycler -1 data/$shortraw\_1.fastq -2 data/$shortraw\_2.fastq -l data/$nanoraw.fastq -o unicycler_hybrid --threads $nthreads

conda deactivate

assemblyILL=unicycler_short/assembly.fasta
assemblyNANO=unicycler_long/assembly.fasta
assemblyHYB=unicycler_hybrid/read_alignment/all_segments.fasta
quast.py -o quast_hybrid --pe1 data/$shortraw\_1.fastq --pe2 data/$shortraw\_2.fastq --nanopore data/$nanoraw* --glimmer --threads $nthreads -m 1000 -l "illumina, nanopore, hybrid" $assemblyILL $assemblyNANO $assemblyHYB









