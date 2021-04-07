mkdir genome_assembly
cd genome_assembly
mkdir data


# copy raw data with human RNA filtered out
# unmapped.*.fq
cp /projectnb2/ct-shbioinf/bio331/assemble/data/unmapped.*.fq ./data/

fastqc -t 2 data/unmapped.*.fq


# ASSEMBLE##

# velvet
mkdir dirVelvet # output directory
export OMP_NUM_THREADS=8
# run velveth: kmer counting and mapping
velveth dirVelvet 31 -shortPaired -fastq -separate data/unmapped.R1.fq data/unmapped.R2.fq
# run velvetg: graph building and contig finding
velvetg dirVelvet

# MEGAHIT
#installation: run ONLY ONCE, but path specific
wget https://github.com/voutcn/megahit/releases/download/v1.2.9/MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
tar zvxf MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
mv MEGAHIT-1.2.9-Linux-x86_64-static MEGAHIT

#run
./MEGAHIT/bin/megahit -t 8 -1 data/unmapped.R1.fq -2 data/unmapped.R2.fq -o dirMEGAHIT





