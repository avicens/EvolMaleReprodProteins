#!/bin/bash

WORKDIR="/home/uvi/be/avs/lustre/evolution_male_reprod_proteomes"

ORTHOTABLE=$1
GENEDIR=$2

GENELIST=`cut -f1 $ORTHOTABLE`

while read -r gene; do 
mkdir ${GENEDIR}/$gene
done <<<  "$GENELIST"
