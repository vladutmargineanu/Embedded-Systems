#!/bin/bash

write_dev()
{
	echo $1$2 > /dev/epic_clock;
}

write_string()
{
	write_dev ${1:0:1} $2;
	write_dev ${1:1:2} $(($2+1));
}
	

last_second=0;
display_type=0;
dots_en=0;

counter=0

while :
do
	day=$(date '+%d');
	month=$(date '+%m');
	year=$(date '+%y');
	hour=$(date '+%H');
	minut=$(date '+%M');
	second=$(date '+%S');
	s=$(date '+%s');

	if [ $(($s - $last_second)) -eq 1 ]
	then
		dots_en=$((($dots_en+1)%2));	
	fi
		
	if [ $(($s - $last_second)) -eq 1 ] 
	then
		counter=$(($counter+1));
	fi
		
	if [ $counter -eq 2 ] && [ $display_type -eq 1 ]
	then
		display_type=0;
		counter=0;
	fi
	
	if [ $counter -eq 5 ] && [ $display_type -eq 0 ]
	then
		display_type=1;
		counter=0;
	fi

	if [ $dots_en -eq 1 ]
	then	
		write_string "11" 6;
	else
		write_string "00" 6;
	fi
	
	if [ $display_type -eq 0 ]
	then
		write_string $hour 0;
		write_string $minut 2;
		write_string $second 4;	
	else
		write_string $day 0;
		write_string $month 2;
		write_string $year 4;	
	
	fi

	last_second=$s;
	sleep 0.05;
done
