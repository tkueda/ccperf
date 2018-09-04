#!/bin/bash

for file in `find . -name ccperf.log`; do
    total=0
    num_line=0
    while read -r line; do
	total=`echo "scale=2; $total + $line" | bc`
	num_line=`expr $num_line + 1`
    done < <(grep -v Block $file | tail -n +9 | head -n -6 | awk '{print $7}')
    echo $file `echo "scale=2; $total / $num_line" | bc`
done
