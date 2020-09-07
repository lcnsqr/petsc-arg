#! /bin/bash

# CPU
#CSV=averages_cpu_20200826.csv

# GPU
CSV=averages_gpu_20200828.csv

# Default option for CPU
#DEF=gmres,bjacobi

# Default option for GPU
DEF=gmres,icc

# Baseline

BASE=`grep "^$DEF" $CSV | awk -F, '{printf "%.2f", $3}'`

echo "ksp_type,pc_type,speedup"
tail -n +2 $CSV | awk -v base=$BASE -F, '{printf "%s,%s,%.2f\n", $1, $2, base/$3}'
