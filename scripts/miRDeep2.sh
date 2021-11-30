#!/bin/bash
#SBATCH --job-name=miRDeep2 --output=%x.%j.out
#SBATCH --mail-type=END,FAIL --mail-user=sm3679@georgetown.edu
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=1 --time=72:00:00
#SBATCH --mem=4G

#-----------------------------------------------------------------------------#
# This script runs miRDeep2 #
#-----------------------------------------------------------------------------#

#- Go into Conda environment where miRDeep2.pl is  --------------------------------#

source activate conda-env

cd /home/sm3679/culex_smallRNA/miRDeep_dir/

#- Set variables ----------------------------------------------------------------#

genome=/home/sm3679/culex_smallRNA/genome/GCF_015732765.1_VPISU_Cqui_1.0_pri_paternal_genomic.fa
reads=/home/sm3679/culex_smallRNA/miRDeep_dir/processed_reads.fa
arf=/home/sm3679/culex_smallRNA/miRDeep_dir/reads_vs_genome.arf
known_miRNA=/home/sm3679/culex_smallRNA/known_miRNAs/unique_miRNAs.fa


#- RUN miRDeep2.pl ----------------------------------------------------------------#

miRDeep2.pl ${reads} ${genome} ${arf} ${known_miRNA} none none 2> miRDeep2_report.log


#- FIN -----------------------------------------------------------------------#
