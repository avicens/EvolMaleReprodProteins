#!/bin/bash

WORKDIR="/home/uvi/be/avs/lustre/evolution_male_reprod_proteomes"
DATADIR="${WORKDIR}/data"
IDFILE=$1
GENEDIR=$2

while read line; do

GENE=`echo $line | awk '{print $1;}'`
echo "Creating ortholog file for ${GENE}"
ORTHOFILE="${GENE}.orthologs"
echo ${line} | awk 'BEGIN {OFS="\n";} {print $3,$4,$5,$6,$7,$8,$9;}' | grep 'ENS' > ${GENEDIR}/${GENE}/${ORTHOFILE}
done < ${IDFILE}
