#!/bin/bash
#Theodor Semerdzhiev
#Computer Science Department
#theodor.semerdzhiev@mail.mcgill.ca

#====================================================================

#checks if the # of parameters is right, returns exit code 1 if true 
if ! [ $# -eq 2 ] 
then 
	echo "Proper Usage: ./namefix.bash <inputfile> <outputfile>"
	exit 1
fi
InFileName=$(basename $1)
OutFileName=$(basename $2)
#this else if statement checks if input file is the same as the output file
if [ $InFileName == $OutFileName ]
then
	echo "Input and output files can not be the same"
	exit 2

#checks if input file is a directory
elif [ -d $1 ]
then		
	echo "Error: $1 is a directory"
	exit 3
#checks if its not a file
elif ! [ -f $1 ]
then 
	echo "Error: Input file $1 does not exist"
	exit 3
#this else if should check if input file as read permissions 
elif ! [ -r $1 ]
then
	echo "Error: Input file $1 does not have read permissions"
	exit 3
fi
#checks if output file is a directory
if [ -d $2 ]
then
#checks if file that is gonna be created already exists as a directory
	if ! [ -d "$2/$(basename $1)" ]
	then
		#checks if output directory as write permissions
		if [ -w $2 ]
		then
			/home/2013/jdsilv2/206/mini2/namefix $1 "$2/$InFileName"
			exit 0
		else	
			echo "Error: Directory $2 does not have write permissions"
			exit 4
		fi
	else
		echo Error: "$2/$(basename $1)" is a directory 
		exit 4
	fi
fi
#otherwise it just runs the namefix program with given files 	
if [ -f $2 ]
then
		#checks if output file as write permissions
		if [ -w $2 ]
		then
			/home/2013/jdsilv2/206/mini2/namefix $1 $2
			exit 0
		else
			echo "Error: File $2 does not have write permissions"
			exit 4
		fi
#if file does not exist, we assume namefix program will create it for us
else
	#must check directory as write permissions, since namefix will have to create a file
	if [ -w $(dirname $2) ]
	then
		/home/2013/jdsilv2/206/mini2/namefix $1 $2
		exit 0
	else
		echo "Directory $(dirname $2) does not have write permissions"
		exit 4
	fi
fi
