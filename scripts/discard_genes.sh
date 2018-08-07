#!/bin/bash

#Setting directories and files
WORKDIR="/mnt/lustre/scratch/home/uvi/be/avs/evolution_male_reprod_proteomes"
GENEDIR="${WORKDIR}/genes/testis"
DISCDIR="${WORKDIR}/genes/discarded_genes/testis"
GENENAMES=`ls ${GENEDIR}`
DISCGENES=`cat ${WORKDIR}/raxml_err`

while read -r num; do
echo "the gene ${num} is ${gene}" 
gene=`ls ${GENEDIR} | sed -n "${num}p;"`
mv ${GENEDIR}/${gene} ${DISCDIR}
done <<< "${DISCGENES}"
