#! /bin/bash

TMP=`mktemp`

LOG_DIR=gpu

if [ $0 == 'parse_gpu.sh' ]
then
  LOG_DIR=gpu
fi

sed -n -f parse.sed $LOG_DIR/slurm-*.out > $TMP 

echo ksp_type,pc_type,response

TOTAL=`wc -l < $TMP`

for l in `seq 1 3 $TOTAL`
do
	sed -ne "$l,$(( $l + 2))p" < $TMP | tr '\n' ' ' | awk '{printf "%s,%s,%.2f\n", $2, $3, $1}'
done

rm $TMP
