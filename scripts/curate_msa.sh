#!/bin/bash

#Setting directories and files
WORKDIR="/mnt/lustre/scratch/home/uvi/be/avs/evolution_male_reprod_proteomes"
GENEDIR="${WORKDIR}/genes/control"
GENENAMES=`ls ${GENEDIR}`

while read -r gene; do
echo "curating alignment for ${gene}"
cd ${GENEDIR}/${gene}/
awk '/^>/{f=!d[$1];d[$1]=1}f' ${gene}_align_DNA.fasta | sed 's/!/N/g' | cut -d'|' -f1 > ${gene}_align_DNA_curated.fasta

done <<< "${GENENAMES}"
