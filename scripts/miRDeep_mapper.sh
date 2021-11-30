#!/bin/bash
#SBATCH --job-name=miRDeep_mapper --output=%x.%j.out
#SBATCH --mail-type=END,FAIL --mail-user=sm3679@georgetown.edu
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=1 --time=72:00:00
#SBATCH --mem=4G

#-----------------------------------------------------------------------------#
# This script runs mapper.pl to make an ARF file for miRDeep2 #
#-----------------------------------------------------------------------------#

#- Go into Conda environment where mapper.pl is  --------------------------------#

source activate conda-env

#- Set variables ----------------------------------------------------------------#

config_file=/home/sm3679/culex_smallRNA/miRDeep_dir/config_file.txt
genome_index=/home/sm3679/culex_smallRNA/genome/indexed/Cqu
output_reads=/home/sm3679/culex_smallRNA/miRDeep_dir/processed_reads.fa
output_arf=/home/sm3679/culex_smallRNA/miRDeep_dir/reads_vs_genome.arf


#- RUN mapper.pl ----------------------------------------------------------------#

mapper.pl ${config_file} -d -e -h -j -l 18 -m -p ${genome_index} -s ${output_reads} -t ${output_arf}



#- FIN -----------------------------------------------------------------------#
