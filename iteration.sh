#!/bin/bash
declare -i number permit count mark count_marked incre_row bias fix
let base_row+=1
let mark=0
for ((column=1;column<=8;column++))
do
	if [ $mark -eq 1 ]; then    # on the same row, wash for the moving.
		for ((i=1;i<=${#marked[@]};i++))
		do
			let place_${marked[$i]}-=1
		done
		unset marked
		let mark=0
	fi
	let number=$base_row*8+$column
	eval permit=\$place_$number
	if [ $permit -eq 0 ]; then
		let position_$base_row=$column
		if [ $base_row -eq 7 ]; then
			read count < count_file
			let count+=1
			echo $count > count_file
			echo "  The answer No.$count"
			declare -a forprint
			for ((i=0;i<=7;i++))
			do
				for ((j=1;j<=8;j++))
				do
					forprint[$j]=-
				done
				forprint[position_$i]=Q
				echo ${forprint[@]}
			done
			unset forprint
		else
			declare -a marked         # where the new Q conflict.
			let count_marked=0
			for ((row=$base_row;row<=6;row++))
			do
				let number=($row+1)*8+$column
				let incre_row=$row-$base_row+1
				let bias=$column-$incre_row       # slope left
				if [ $bias -gt 0 ]; then
					let fix=$number-$incre_row
					let place_$fix+=1
					let count_marked+=1
					let marked[$count_marked]=$fix
				fi
				let place_$number+=1
				let count_marked+=1
				let marked[$count_marked]=$number
				let bias=$column+$incre_row        # slope right
				if [ $bias -lt 9 ]; then
					let fix=$number+$incre_row
					let place_$fix+=1
					let count_marked+=1
					let marked[$count_marked]=$fix
				fi
			done
			let mark=1
			./iteration.sh
		fi
	fi
done
