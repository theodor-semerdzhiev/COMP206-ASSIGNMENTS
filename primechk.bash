#!/usr/bin/bash

#Theodor Semerdzhiev
#Department of Computer Science
#theodor.semerdzhiev@mail.mcgill.ca

f_present=0
l_present=0
file_present=0;
#checks if program is given the proper # of parameters
if [ $# -lt 2 ]||[ $# -gt 3 ]
then
	echo "incorrect # of parameters"
	echo "Usage: ./primechk.sh -f <file> [-l]"
	exit 1
fi
#case 1: -f as first argument
if [ $1 == "-f" ] 
then
f_present=1
	if [[ -f $2 ]]
	then
	file_present=1
		if [[ $3 == "-l" ]]
		then
		l_present=1
		elif [ $# -eq 3 ] 
		then
		echo "$3 is not valid"
		exit 1
		fi
	File=$2	
	else
	echo "File $2 was not found"
	exit 2
	fi
#case 2: -l as first argument
elif [ $1 == "-l" ]
then
l_present=1
	if [ $2 == "-f" ]
	then
		f_present=1
		if [[ -f $3 ]]
		then
		file_present=1
		File=$3
		else
		echo "File $3 was not found"
		exit 2
		fi
	else 
		echo improper usage
		echo "Usage: ./primechk.sh -f <file> [-l]"
		exit 1
	fi
else
echo $1 is not a valid argument
echo "Usage: ./primechk.sh -f <file> [-l]"
exit 1
fi
#Creates an array with all valid numbers from file
AllNumbers=($(grep ^[0-9]*" *"$ $File))
#Creates empty array that will contain the prime numbers
PrimeNumber=()
#Checks if array numbers are primes 
for i in ${AllNumbers[@]}
do
	/home/2013/jdsilv2/206/mini2/primechk $i 1> /dev/null 
	#if program ran succesfully it will add prime number to PrimeNumber array
	if [ $(echo $?) -eq 0 ]
	then
		PrimeNumber+=($i)
	fi
done
#checks if primes were found
if [ ${#PrimeNumber[@]} -eq 0 ]
then
echo "No primes found in file $File"
	if [ $l_present -eq 1 ]
	then
		exit 3
	else
		exit 0
	fi
fi
#if no -l argument is found, script simply prints all prime numbers
if [ $l_present -eq 0 ]
then	
for i in ${PrimeNumber[@]}
do 
	echo $i
done
#Gets biggest Number from prime array if -l argument is found
elif [ $l_present -eq 1 ]
then
BigNum=${PrimeNumber}
for ((i=1; i < ${#PrimeNumber[@]}; i++))
do
	if [ ${PrimeNumber[$i]} -gt $BigNum ]
	then
	BigNum=${PrimeNumber[$i]}
	fi
done
echo $BigNum
fi
exit 0
