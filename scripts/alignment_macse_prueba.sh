#!/bin/bash

#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task 4
#SBATCH -t 01:00:00
#SBATCH --mem 6G

#Setting directories and files
TOOLSDIR="/home/uvi/be/avs/lustre/tools"
WORKDIR="/home/uvi/be/avs/lustre/evolution_male_reprod_proteomes"
GENEDIR="${WORKDIR}/genes/control"


GENE=`ls ${GENEDIR} | head -1`
seqfile="${GENEDIR}/${GENE}/${GENE}_cds.fas"

module load jdk/1.8.0

echo "Running codon alignment of ${GENE} sequences"
java -jar ${TOOLSDIR}/macse_v0.9b1.jar -i ${seqfile} -g -7 -x -1 -f -30 -d 1 -s -100 -o ${GENEDIR}/${GENE}/${GENE}_align
