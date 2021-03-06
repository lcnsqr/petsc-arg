#! /bin/bash

LC_ALL=C

# Load computed averages
if [ $# -lt 1 ]
then
  echo -e "Argument missing. Usage:\n\n$0 path/to/CSV\n"
  exit
fi
  
CSV=$1

# CPU
TARGET=cpu

if [ $0 == "./heatmap_gpu.sh" ]
then
  # GPU
  TARGET=gpu
fi

readarray -t AVERAGES < $CSV

# Load colors
readarray -t COLORS < colors.txt

# Field to compute
# 3: Main stage execution time
# 4: Standard deviation
# 5: Confidence interval
FIELD=3

MIN=`tail -n +2 "$CSV" | cut -d, -f3| sort -g| head -1`
MAX=`tail -n +2 "$CSV" | cut -d, -f3| sort -r -g| head -1`

cp template_$TARGET.html heatmap_$TARGET.html

sed -i -e "s/#min#/$MIN/" -e "s/#max#/$MAX/" heatmap_$TARGET.html

for (( l = 1; l < ${#AVERAGES[*]}; l++ ))
do
  KSP_TYPE=`cut -d',' -f 1 <<<"${AVERAGES[l]}"`
  PC_TYPE=`cut -d',' -f 2 <<<"${AVERAGES[l]}"`
  TIME=`cut -d',' -f 3 <<<"${AVERAGES[l]}"`
  SD=`cut -d',' -f 4 <<<"${AVERAGES[l]}"`
  CI=`cut -d',' -f 5 <<<"${AVERAGES[l]}"`
  COLOR=`cut -d',' -f $FIELD <<<"${AVERAGES[l]}" | awk -v min=$MIN -v max=$MAX -v colors=${#COLORS[*]} '{printf "%d\n", (colors-1) * ($1 - min)/(max - min)}'`

  printf "ksp_type: %s\n" $KSP_TYPE
  printf "pc_type: %s\n" $PC_TYPE
  printf "Tempo: %s\n" $TIME
  printf "Desvio padrão: %s\n" $SD
  printf "Intervalo de confiança: %s\n" $CI
  printf "Cor: %s\n" ${COLORS[$COLOR]}

  sed -i -e "/^<!-- $KSP_TYPE.$PC_TYPE -->/s/#color#/${COLORS[$COLOR]}cc/" -e "/^<!-- $KSP_TYPE.$PC_TYPE -->/s/#value#/$TIME/" -e "/^<!-- $KSP_TYPE.$PC_TYPE -->/s/#ci#/IC: $CI/" heatmap_$TARGET.html
done
