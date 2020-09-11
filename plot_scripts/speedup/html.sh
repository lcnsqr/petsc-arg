#! /bin/bash

ksp_type=("cg" "gmres" "fcg" "tcqmr" "cgs" "bcgs" "tfqmr" "cr" "gcr")

pc_type=("bjacobi" "jacobi" "sor" "mg")

for (( j = 0; j < ${#ksp_type[*]}; j++ ))
do
  printf "<tr><td>solver</td>\n"
	for (( i = 0; i < ${#pc_type[*]}; i++ ))
  do
    printf "<!-- %s.%s --><td style=\"background-color: #color#\"><p>#value#</td>\n" ${ksp_type[$j]} ${pc_type[$i]}
  done
  printf "</tr>\n"
done
