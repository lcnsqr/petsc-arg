#! /bin/bash

LC_ALL=C

# Load computed averages
if [ $# -lt 2 ]
then
  echo -e "Argument missing. Usage:\n\n$0 <machine> <path/to/CSV>\n"
  exit
fi
  
MACHINE=$1

CSV=$2

# CPU
TARGET=cpu

# Default option for CPU
DEF=gmres,bjacobi

if [ $0 == "./timings_html_gpu.sh" ]
then
  # GPU
  TARGET=gpu
  # Default option for GPU
  DEF=gmres,icc
fi

# Baseline time
BASE=`grep "^$DEF" $CSV | awk -F, '{printf "%.2f", $3}'`

readarray -t AVERAGES < $CSV

# Field to compute
# 3: Main stage execution time
# 4: Standard deviation
# 5: Confidence interval
FIELD=3

MIN=`tail -n +2 "$CSV" | cut -d, -f3| sort -g| head -1`
MAX=`tail -n +2 "$CSV" | cut -d, -f3| sort -r -g| head -1`

OUTFILE=`basename ${CSV%.csv*}.html`

cp template_timings_$TARGET.html $OUTFILE

sed -i -e "s/#min#/$MIN/" -e "s/#max#/$MAX/" $OUTFILE

sed -i -e "s/#machine#/$MACHINE/" $OUTFILE

for (( l = 1; l < ${#AVERAGES[*]}; l++ ))
do
  KSP_TYPE=`cut -d',' -f 1 <<<"${AVERAGES[l]}"`
  PC_TYPE=`cut -d',' -f 2 <<<"${AVERAGES[l]}"`
  TIME=`cut -d',' -f 3 <<<"${AVERAGES[l]}"`
  SD=`cut -d',' -f 4 <<<"${AVERAGES[l]}"`
  CI=`cut -d',' -f 5 <<<"${AVERAGES[l]}"`

  printf "ksp_type: %s\n" $KSP_TYPE
  printf "pc_type: %s\n" $PC_TYPE
  printf "Tempo: %s\n" $TIME
  printf "Desvio padrão: %s\n" $SD
  printf "Intervalo de confiança: %s\n" $CI

  if [ $TIME == $BASE ]
  then
    DIRECTION="same-time"
    ARROW="⏸"
  else
    DIRECTION=`awk '{if ( $1 >= $2 ) printf "faster"; else printf "slower"}' <<<"$BASE $TIME"`
    ARROW=`awk '{if ( $1 >= $2 ) printf "🠟"; else printf "🠝"}' <<<"$BASE $TIME"`
  fi

  if [ $TIME == $MAX ]
  then
    sed -i -e "s/#worstparms#/$KSP_TYPE\/$PC_TYPE/" $OUTFILE
  fi

  if [ $TIME == $MIN ]
  then
    sed -i -e "s/#bestparms#/$KSP_TYPE\/$PC_TYPE/" $OUTFILE
  fi

  sed -i -e "/^<!-- $KSP_TYPE.$PC_TYPE -->/s/#direction#/$DIRECTION/" \
         -e "/^<!-- $KSP_TYPE.$PC_TYPE -->/s/#value#/$TIME/" \
         -e "/^<!-- $KSP_TYPE.$PC_TYPE -->/s/#ci#/±$CI/" \
         -e "/^<!-- $KSP_TYPE.$PC_TYPE -->/s/#arrow#/$ARROW/" $OUTFILE
done
