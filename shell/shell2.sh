# shell workshop notes
# first, cd to new working directory with workshop files

cd /projectnb/ct-shbioinf/bio331/shell-genomics/shell_data/untrimmed_fastq # navigate to data

ls

# find files that end in .fastq
ls *.fastq

# find files that end in 8026.fastq?
ls *8026.*

# examining files
cat SRR098026.fastq

# print just the first part of a file
head SRR098026.fastq

less SRR098026.fastq # get out of this browser with 'q'
# see also: 'tail', and 'more'

# things we want to do with files
# cp
cp SRR098026.fastq SRR098026-rharbert.fastq

# create a new folder and move backup data to it
mkdir backup # create a new folder: 'make directory'
mv SRR098026-rharbert.fastq backup/


# section 4: Redirection
# searching within a file
# grep
# how many lines have NNNNNNNN indicating ambiguous sequences
grep NNNNNNNNN SRR098026.fastq

# which sequences: view lines before (B) and after (A)
grep -B1 -A2 NNNNNNNNN SRR098026.fastq

# redirect output
grep -B1 -A2 NNNNNNNNN SRR098026.fastq > badreads.fastq

# how much of the data were bad
# wc 'wordcount'
wc badreads.fastq
# wc -l 'linecount'
wc -l badreads.fastq

# pipes |
# catch output of grep and redirect to less
grep -B1 -A2 NNNNNNNNN SRR098026.fastq | less


