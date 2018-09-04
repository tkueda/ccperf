#!/bin/bash


for file in `find . -name sut.sar.out`; do
        echo -n "$file "
        grep all "$file" | \
        grep -v scall | \
        awk '{ if (NF == 13) print $0}' | \
        tail -n +6 | \
        head -n 12 | \
        awk '{ for (i = 4; i <= 13; i++) { num[i] += $i } } END { for (i = 4; i <= 13; i++) printf num[i]/12 " "; printf "\n" }'
done

