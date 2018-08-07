#!/bin/bash

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 3
#SBATCH --cpus-per-task 8
#SBATCH -t 00:30:00
#SBATCH --mem 6G

#Setting directories and files
WORKDIR="/mnt/lustre/scratch/home/uvi/be/avs/evolution_male_reprod_proteomes"
GENEDIR="${WORKDIR}/genes/control"

gene=`ls ${GENEDIR} | sed "4q;d"`

module load miniconda
source activate /home/uvi/be/avs/lustre/tools/miniconda_avs

echo "Running Codeml for ${gene}"
ete3 evol -t ${GENEDIR}/${gene}/${gene}.raxml.bestTree --alg ${GENEDIR}/${gene}/${gene}_align_DNA_trimmed.fasta --codeml_param CodonFreq,3 ncatG,4 verbose,0 --models M0 M8 M8a --cpu 3 --tests M8,M8a -o ${GENEDIR}/${gene}/paml > ${GENEDIR}/${gene}/${gene}_paml.out
