#! /bin/bash

LC_ALL=C

if [ $# -lt 1 ]
then
  echo -e "Argument missing. Usage:\n\n$0 path/to/CSV\n"
  exit
fi
  
CSV=$1

ksp_type=("cg" "gmres" "fcg" "tcqmr" "cgs" "bcgs" "tfqmr" "cr" "gcr")

# CPU
pc_type=("bjacobi" "jacobi" "sor" "mg")

if [ $0 == "./averages_gpu.sh" ]
then
  # GPU
  pc_type=("icc" "jacobi" "sor" "mg")
fi

# Field to compute
# 3: Main stage execution time
# 4: Load average in the last minute
# 5: Load average in the last five minutes
# 6: Load average in the last fifteen minutes
FIELD=3

# How many bad values to discard
DISCARD=0

echo "ksp_type,pc_type,mean,sd,ci"

for (( j = 0; j < ${#ksp_type[*]}; j++ ))
do
	for (( i = 0; i < ${#pc_type[*]}; i++ ))
  do
    # Sample size
    N=`grep "^${ksp_type[$j]},${pc_type[$i]}" < "$CSV" | sort -g -k $FIELD | head -n -$DISCARD | wc -l`

    # Mean
    MEAN=`grep "^${ksp_type[$j]},${pc_type[$i]}" < "$CSV" | tr ',' ' ' | sort -g -k $FIELD | head -n -$DISCARD | awk -v n=$N '{sum+=$3} END {printf "%f", sum/n}'`

    # Variance
    VARIANCE=`grep "^${ksp_type[$j]},${pc_type[$i]}" < "$CSV" | tr ',' ' ' | sort -g -k $FIELD | head -n -$DISCARD | awk -v n=$N -v mean=$MEAN '{sum+=($3-mean)^2} END {printf "%f", sum/n}'`

    # Standard deviation
    SD=`awk '{printf "%f", sqrt($1)}' <<<$VARIANCE`

    # Confidence interval (95%)
    CI=`echo $SD $N | awk '{printf "%f", 1.96 * $1 / sqrt($2)}'`

    printf "%s,%s,%.2f,%.2f,%.2f\n" ${ksp_type[$j]} ${pc_type[$i]} $MEAN $SD $CI

  done
done
