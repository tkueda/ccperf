#!/bin/bash

for file in `find . -name sut.sar.out`; do
        echo -n "$file "
        grep kbmemfree -A 1 $file | \
        grep -v '\-\-' | \
        awk '{ if (NR % 2 == 0) print $0 }' | \
        tail -n +6 | \
        head -n 12 | \
        awk '{ for (i = 3; i <= 17; i++) { num[i] += $i } } END { for (i = 3; i <= 17; i++) printf num[i]/NR " "; printf "\n" }'
done
