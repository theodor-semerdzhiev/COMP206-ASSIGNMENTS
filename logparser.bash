#!/bin/bash
#Theodor Semerdzhiev 
#Faculty of Science 
#theodor.semerdzhiev@mail.mcgill.ca


#Checks for proper number of arguments
if ! [ $# -eq 1 ]
then
	echo "Proper Usage: ./logparser.bash <logdir>"
	exit 1
fi
#checks for proper directory 
if ! [ -d $1 ]
then
	echo "Error: $1 is not a valid directory"
	exit 2
fi
 
log_files=($(ls $1))

#We loop through each file in the dir
for file in ${log_files[@]}
do
sender=$(sed -e 's/[.]/:/g' -e 's/.\log$//' <<< $file)
broadcast_lines=$(grep -c 'DISLXXX.gcl.GCL broadcastMsg FINE: Broadcast message request received. Translating to point-to-point messages : '[1-9] $1/$file)
	#loop throught each broadcast message
	for (( i=1; i < $broadcast_lines+1; i++ ))
	do		
		broadcast_time=$(grep 'DISLXXX.gcl.GCL broadcastMsg FINE: Broadcast message request received. Translating to point-to-point messages : '[1-9] $1/$file | awk '{if(NR=='$i') print $4}')
		#for every broodcast message, we loop throught each .log file to find the received and delivered message
		for file1 in ${log_files[@]}
		do
			reicever=$(sed -e 's/[.]/:/g' -e 's/.\log$//' <<< $file1)
			received_time=$(grep 'DISLXXX\.gcl\.GCL$GCLInbox run FINE: '$sender:' Received a message from\. message: \[senderProcess:'$sender:'val:'$i'\]$'  $1/$file1 | awk '{ print $4}' )
			#if received time is not found then there can not be delivered time 
			if ! [ -z $received_time ]
			then
			delivered_time=$(grep 'DISLXXX\.dem206\.GCLDemoCounter deliver INFO: Received :'$i' from : '$sender'$' $1/$file1 | awk '{print $4}')
			fi
			echo $sender,$i,$reicever,$broadcast_time,$received_time,$delivered_time
		done
			received_time=
			delivered_time=
	done	
done > logdata.csv
{
#creates the header for the cvs file
for ((j=0; j < ${#log_files[@]} ; j++ ))
do
	if [ $j -eq 0 ]
	then
	       	echo -n "broadcaster,nummsgs,${log_files[$j]}"
	else
		echo -n ",${log_files[$j]}"
	fi
done
echo
#adds sender and # of broadcasts and proper commas 
for ((k=0;k<${#log_files[@]};k++))
do
	#itterate throught the line
	for ((j=0;j < ${#log_files[@]}+2 ; j++))
	do
		if [ $(grep -c 'DISLXXX.gcl.GCL broadcastMsg FINE: Broadcast message request received. Translating to point-to-point messages : '[1-9] $1/${log_files[$k]}) -eq 0 ]
		then
		break
		#sender process
		elif [ $j -eq 0 ]
		then
			Sender_noFormat=${log_files[$k]}
			echo -n "${log_files[$k]}"
		#number of broadcasts
		elif [ $j -eq 1 ]
		then
			NumMsg=$(grep -c 'DISLXXX.gcl.GCL broadcastMsg FINE: Broadcast message request received. Translating to point-to-point messages : '[1-9] $1/${log_files[$k]})
			echo -n ,$NumMsg
		else
		#if field is not sender or number of messages, then it must be a percentage	
			Sender="$(sed -e 's/[.]/:/g' -e 's/.\log$//' <<< $Sender_noFormat)"
			num=$(expr $j + 1)	
			Receiver=$(awk -F',' '{if (NR==1) print $'$num'}' stats.csv )
			NumDelivered=$(grep -c 'DISLXXX\.dem206\.GCLDemoCounter deliver INFO: Received :[0-9]* from : '$Sender'$' $1/$Receiver)
			echo -n ",$(awk -v var1=$NumDelivered -v var2=$NumMsg 'BEGIN { print  ( 100 * (var1 / var2 )) }')"
		fi
	done
	echo
done 
} > stats.csv
#sed command removes empty lines
sed -i '/^$/d' stats.csv
#this loop properly formats the name of the process in the cvs file
for ((k=0;k<${#log_files[@]};k++))
do
Sender="$(sed -e 's/[.]/:/g' -e 's/.\log$//' <<< ${log_files[$k]})"
sed -i 's/'${log_files[$k]}'/'$Sender'/g' stats.csv
done
#redirects output of this clause into stats.html
{
echo "<HTML>"
echo "<BODY>"
echo "<H2>GC Efficiency</H2>"
echo "<TABLE>"
#goes across each line and replaces comma with html tags
cat stats.csv | while read line || [[ -n $line ]];
do
	echo "<TR><TD>$(sed 's/,/<\/TD><TD>/g' <<< $line)</TR>"
done
echo "</TABLE>"
echo "</BODY>"
echo "</HTML>"
} > stats.html

