#! /bin/bash

if [ $# -lt 1 ]
then
  echo -e "Argument missing. Usage:\n\n$0 path/to/CSV\n"
  exit
fi
  
CSV=$1

# Default option for CPU
DEF=gmres,bjacobi

if [ $0 == "./speedup_gpu.sh" ]
then
  # Default option for GPU
  DEF=gmres,icc
fi

# Baseline

BASE=`grep "^$DEF" $CSV | awk -F, '{printf "%.2f", $3}'`

echo "ksp_type,pc_type,speedup"
tail -n +2 $CSV | awk -v base=$BASE -F, '{printf "%s,%s,%.2f\n", $1, $2, base/$3}'
