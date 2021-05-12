

# download and unzip unknown viral metagenomes
wget https://sra-pub-sars-cov2.s3.amazonaws.com/sra-src/SRR11092062/v300043428_L02_127_1.fq.gz

mv v300043428_L02_127_1.fq.gz viral_metagenome.fq.gz

gunzip viral_metagenome.fq.gz


# set up kraken database
kraken2-build --download-library "viral" --threads 8 --db krakendb
kraken2-build --download-taxonomy --threads 8 --db krakendb
kraken2-build --build --db krakendb

# use variables for kraken database and target data
kdb=krakendb
targdata=viral_metagenome.fq

# Run kraken with default settings
kraken2 --db $kdb  --threads 8 --use-names --report kreport.tab $targdata > kraken.out

# Run kraken with confidence filtering
kraken2 --db $kdb  --threads 8 --confidence 0.9 --use-names --report kreport_conf.tab $targdata > kraken_conf.out