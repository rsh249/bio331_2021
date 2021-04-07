#!/usr/bin/bash
# Your Name (2021)
# add info about running the script
# programs required


echo "Running a pipeline for genome assembly"

# instructions 

# create dir for pipeline
mkdir assembly1
cd assembly1
mkdir data

# copy the unmapped reads files
cp /projectnb2/ct-shbioinf/bio331/assemble/data/unmapped.*.fq ./data/

# fastqc quality check
fastqc -t 2 data/unmapped.*.fq

# run MEGAHIT
megahit -t 8 -1 data/unmapped.R1.fq -2 data/unmapped.R2.fq  -o dirMEGAHIT





