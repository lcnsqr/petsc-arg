#! /bin/bash

# Distribuição dos experimentos por duração

LC_ALL=C

CSV=../ExperimentalDesign/cpu_20200826.csv
#CSV=../ExperimentalDesign/gpu_20200828.csv

ksp_type=("cg" "gmres" "fcg" "tcqmr" "cgs" "bcgs" "tfqmr" "cr" "gcr")

# CPU
pc_type=("bjacobi" "jacobi" "sor" "mg")

# GPU
#pc_type=("icc" "jacobi" "sor" "mg")

# CPU intervals
COL=60
SLOTS=(`seq 60 $COL 960`)

# GPU intervals
#COL=120
#SLOTS=(`seq 120 $COL 2280`)

# Field to compute
# 3: Main stage execution time
# 4: Load average in the last minute
# 5: Load average in the last five minutes
# 6: Load average in the last fifteen minutes
FIELD=3

# How many bad values to discard
DISCARD=0

# Lowest time
LOW=9999999999999

# Highest time
HIGH=0

for (( j = 0; j < ${#ksp_type[*]}; j++ ))
do
	for (( i = 0; i < ${#pc_type[*]}; i++ ))
  do

    LOCAL_LOW=`grep "^${ksp_type[$j]},${pc_type[$i]}" < "$CSV" | tr ',' ' ' | sort -g -k $FIELD | head -n -$DISCARD | head -n 1 | cut -d' ' -f $FIELD`
    LOCAL_HIGH=`grep "^${ksp_type[$j]},${pc_type[$i]}" < "$CSV" | tr ',' ' ' | sort -g -k $FIELD | head -n -$DISCARD | tail -n 1 | cut -d' ' -f $FIELD`

    if [ "${LOCAL_LOW%.*}" -lt "$LOW" ]
    then
      LOW=${LOCAL_LOW%.*}
    fi

    if [ "${LOCAL_HIGH%.*}" -gt "$HIGH" ]
    then
      HIGH=${LOCAL_HIGH%.*}
    fi

  done
done

printf "LOW: %d\nHIGH: %d\n" $LOW $HIGH > /dev/stderr

declare -a COLS
for (( s = 0; s < ${#SLOTS[*]}; s++ ))
do
  COLS[$s]=0;
done

for (( j = 0; j < ${#ksp_type[*]}; j++ ))
do
	for (( i = 0; i < ${#pc_type[*]}; i++ ))
  do
    FLOATS=(`grep "^${ksp_type[$j]},${pc_type[$i]}" < "$CSV" | tr ',' ' ' | sort -g -k $FIELD | head -n -$DISCARD | cut -d' ' -f $FIELD`)
    for (( f = 0; f < ${#FLOATS[*]}; f++ ))
    do
      FLOAT=${FLOATS[$f]}
      for (( s = 0; s < ${#SLOTS[*]}; s++ ))
      do
        if [ "${FLOAT%.*}" -lt "${SLOTS[$s]}" ]
        then
          COLS[$s]=$(( ${COLS[$s]} + 1 ))
          break;
        fi
      done
    done
  done
done

for (( s = 0; s < ${#SLOTS[*]}; s++ ))
do
  printf "\"(%d,%d]\"\t%d\n" $(( (${SLOTS[$s]} - $COL) / 60 )) $(( ${SLOTS[$s]} / 60 )) ${COLS[$s]}
done
