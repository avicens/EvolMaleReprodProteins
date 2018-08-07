#!/bin/bash

WORKDIR="/mnt/lustre/scratch/home/uvi/be/avs/evolution_male_reprod_proteomes"
SCRIPTDIR="${WORKDIR}/scripts"

## Create a folder and put slurm output inside
pipeline_name=`basename $0`
slurm_info=$(echo `date` | awk -v argument=$pipeline_name '{print argument"_"$3"-"$2"-"$6"_"$4}')
mkdir -p $slurm_info
cd $slurm_info

sbatch --array=1-100 -p shared --qos shared ${SCRIPTDIR}/run_paml_array.sh
