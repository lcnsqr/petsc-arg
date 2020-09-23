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

if [ $0 == "./speedup_html_gpu.sh" ]
then
  # GPU
  TARGET=gpu
fi

readarray -t AVERAGES < $CSV

# Field to compute
# 3: Main stage execution time
FIELD=3

MIN=`tail -n +2 "$CSV" | cut -d, -f3| sort -g| head -1`
MAX=`tail -n +2 "$CSV" | cut -d, -f3| sort -r -g| head -1`

cp template_speedup_$TARGET.html ${CSV%.csv*}.html

sed -i -e "s/#min#/$MIN/" -e "s/#max#/$MAX/" ${CSV%.csv*}.html

sed -i -e "s/#machine#/$MACHINE/" ${CSV%.csv*}.html

for (( l = 1; l < ${#AVERAGES[*]}; l++ ))
do
  KSP_TYPE=`cut -d',' -f 1 <<<"${AVERAGES[l]}"`
  PC_TYPE=`cut -d',' -f 2 <<<"${AVERAGES[l]}"`
  SPEEDUP=`cut -d',' -f 3 <<<"${AVERAGES[l]}"`

  if [ $SPEEDUP == "1.00" ]
  then
    DIRECTION=same
    ARROW="⏸"
  else
    DIRECTION=`awk '{if ( $1 <= 1.0 ) printf "down"; else printf "up"}' <<<$SPEEDUP`
    ARROW=`awk '{if ( $1 <= 1.0 ) printf "🠟"; else printf "🠝"}' <<<$SPEEDUP`
  fi

  printf "ksp_type: %s\n" $KSP_TYPE
  printf "pc_type: %s\n" $PC_TYPE
  printf "speedup: %s\n" $SPEEDUP

  if [ $SPEEDUP == $MIN ]
  then
    sed -i -e "s/#worstparms#/$KSP_TYPE\/$PC_TYPE/" ${CSV%.csv*}.html
  fi

  if [ $SPEEDUP == $MAX ]
  then
    sed -i -e "s/#bestparms#/$KSP_TYPE\/$PC_TYPE/" ${CSV%.csv*}.html
  fi

  sed -i -e "/^<!-- $KSP_TYPE.$PC_TYPE -->/s/#direction#/$DIRECTION/" \
         -e "/^<!-- $KSP_TYPE.$PC_TYPE -->/s/#value#/$SPEEDUP/" \
         -e "/^<!-- $KSP_TYPE.$PC_TYPE -->/s/#arrow#/$ARROW/" ${CSV%.csv*}.html
done
