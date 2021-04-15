# create a new software environment with conda
conda create -y --name py368 python==3.6.8

conda init

# activate that environment
conda activate py368

# install unicycler & dependencies
conda install -c bioconda unicycler



conda deactivate 