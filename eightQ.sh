#!/bin/bash
# place_j j:1~64. if place_j eq 0, to place a Q at j enable; gt 0, disable.
for ((j=1;j<=64;j++))
do
	declare place_$j=0
	export place_$j
done

# the Q be placed in row-j j:0~7, its column-number is position_j.
for ((j=0;j<8;j++))
do
	declare position_$j=0
	export position_$j
done

declare -i base_row
let base_row=-1
export base_row
echo 0 > count_file
./iteration.sh
rm count_file
