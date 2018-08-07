#!/bin/bash

#Setting directories and files
WORKDIR="/mnt/lustre/scratch/home/uvi/be/avs/evolution_male_reprod_proteomes"
GENEDIR="${WORKDIR}/genes/control"
GENENAMES=`ls ${GENEDIR}`

while read -r gene; do
echo "trimming alignment for ${gene}"
trimal -in ${GENEDIR}/${gene}/${gene}_align_DNA_curated.fasta -out ${GENEDIR}/${gene}/${gene}_align_DNA_trimmed.fasta -gt 0.4 -st 0.1
done <<< "${GENENAMES}"
