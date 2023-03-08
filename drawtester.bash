#Theodor Semerdzhiev
#McGill ID: 261118892
#Faculty of Science

#!/bin/bash

if [[ ! -f asciidraw.c ]] #checks if file is present in current directory 
then
	echo "Error cannot locate asciidraw.c"
	exit 1
fi

gcc -o asciidraw.out asciidraw.c -lm
rc=$?

if [[ $rc -ne 0 ]] #checks if .c file compiled properly, if not prints error code
then
	echo "There were errors/warnings from gcc. rc = $rc"
	exit $rc
fi

#####################################################

echo " --- test case to draw simple lines, vertical,horizontal, and diagonal --- "

echo
echo TEST 1:
echo
#Prints lines with negative and positive slopes
echo '
GRID 80 80
LINE 20,20 80,70
CHAR +
LINE 50,5 50,20
LINE 1,1 60,19
CHAR %
LINE 4,70 10,5
DISPLAY
LINEE 20,20 30,35
END
'

./asciidraw.out <<ENDOFCMDS
GRID 80 80
LINE 20,20 80,70
CHAR +
LINE 50,5 50,20
LINE 1,1 60,19
CHAR %
LINE 4,70 10,5
DISPLAY
LINEE 20,20 30,35
END
ENDOFCMDS

echo 
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo

############

echo
echo TEST 2:
echo

#for high magnitude slopes
echo '
GRID 50 50
LINE 1,40 3,5
LINE 5,5 10,80
DISPLAY
END
'

./asciidraw.out <<ENDOFCMDS
GRID 50 50
LINE 1,40 3,5
LINE 10,5 15,50
DISPLAY
END
ENDOFCMDS


echo 
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo

#############

echo
echo TEST 3:
echo

#tests vertical and horizontal lines
echo '
GRID 50 50
LINE 5,5 5,25
LINE 10,5 10,40
CHAR #
LINE 5,25 10,25
LINEE 20,20 30,30
DISPLAY 
END
'

./asciidraw.out <<ENDOFCMDS
GRID 50 50
LINE 5,5 5,25
LINE 10,5 10,40
CHAR #
LINE 5,25 10,25
LINEE 20,20 30,30
DISPLAY 
END
ENDOFCMDS

echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo

##############################################################

echo " --- test case to draw multiple shapes, switching characters, etc --- "

echo
echo TEST 4:
echo

#prints all types of shapes to screen, with different variables
#Make sure older shapes character are overwritten

echo '
GRID 100 100
RECTANGLE 10,10 80,40
CHAR #
LINE 2,2 15,15
DISPLAY
CHAR +
CIRCLE 30,30 40
CHAR &
RECTANGLE 80,80 40,40
DISPLAY
END
'

./asciidraw.out <<ENDOFCMDS
GRID 100 100
RECTANGLE 10,10 80,40
CHAR #
LINE 2,2 15,15
DISPLAY
CHAR +
CIRCLE 30,30 40
CHAR &
RECTANGLE 80,80 40,40
DISPLAY
END
ENDOFCMDS

echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo

##############

echo
echo TEST 5:
echo

#Look at Test above 
echo '
GRID 20 20
CIRCLE 10,10 2
CHAR #
CIRCLE 15,15 3
LINE 0,7 15,2
CHAR $
RECTANGLE 20,20 0,0
DISPLAY
END
'

./asciidraw.out <<ENDOFCMDS
GRID 20 20
CIRCLE 10,10 2
CHAR #
CIRCLE 15,15 3
LINE 0,7 15,2
CHAR $
RECTANGLE 20,20 0,0
DISPLAY
END
ENDOFCMDS

echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo

##########################################################

echo " --- test cases to draw circles --- "

echo
echo TEST 6:
echo

#draws circles of different sizes to compare their shapes and measure diameter
#Reminder: diameter must be 2r+1

echo '
GRID 50 50
CIRCLE 4,25 1
CHAR @
CIRCLE 15,25 2
CHAR +
CIRCLE 26,25 3
CHAR %
CIRCLE 40,25 4
DISPLAY
CHAR #
CIRCLE 15,15 6
CHAR O
CIRCLE 25,25 20
CHAR 0
CIRCLE 25,25 30
DISPLAY
END
'

./asciidraw.out <<ENDOFCMDS
GRID 50 50
CIRCLE 4,25 1
CHAR @
CIRCLE 15,25 2
CHAR +
CIRCLE 26,25 3
CHAR %
CIRCLE 40,25 4
DISPLAY
CHAR #
CIRCLE 15,25 6
CHAR O
CIRCLE 25,25 20
CHAR 0
CIRCLE 25,25 30
DISPLAY
END
ENDOFCMDS

echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo

#########

echo TEST 7:

#Allows to visualize circle printing algorithm 
echo '
GRID 100 100
CIRCLE 10,10 1
CIRCLE 20,10 2
CIRCLE 30,10 3
CIRCLE 40,10 4
CIRCLE 55,10 5
CIRCLE 75,10 6
CIRCLE 90,10 7
CHAR #
CIRCLE 10,40 8
CIRCLE 25,40 9
CIRCLE 40,40 10
CIRCLE 60,40 11
CIRCLE 80,40 12
CHAR +
CIRCLE 20,70 13
CIRCLE 40,70 14
CIRCLE 60,70 15
CIRCLE 80,70 16
DISPLAY
END
' 
./asciidraw.out <<ENDOFCMDS
GRID 100 100
CIRCLE 10,10 1
CIRCLE 20,10 2
CIRCLE 30,10 3
CIRCLE 40,10 4
CIRCLE 55,10 5
CIRCLE 75,10 6
CIRCLE 90,10 7
CHAR #
CIRCLE 10,40 8
CIRCLE 25,40 9
CIRCLE 40,40 10
CIRCLE 60,40 11
CIRCLE 80,40 12
CHAR +
CIRCLE 20,70 13
CIRCLE 40,70 14
CIRCLE 60,70 15
CIRCLE 80,70 16
DISPLAY
END
ENDOFCMDS

echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo

################################################################

echo '--- test cases to draw rectangles ---'

echo
echo TEST 8
echo

#prints rectangle around the egdes of the visible display to make sure coordinates are proper
#such shapes must be visible 
echo '
GRID 60 60
RECTANGLE 5,5 15,10
CHAR #
RECTANGLE 30,30 40,45
DISPLAY
CHAR %
RECTANGLE 0,0 40,3
DISPLAY
END
'
./asciidraw.out <<ENDOFCMDS
GRID 60 60
RECTANGLE 5,5 15,10
CHAR #
RECTANGLE 30,30 40,45
DISPLAY
CHAR %
RECTANGLE 0,0 40,3
DISPLAY
END
ENDOFCMDS

echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo

########

echo
echo TEST 9
echo

#tests for small rectangles and inverted coordinates 
echo '
GRID 20 20
RECTANGLE 15,15 2,6
DISPLAY
CHAR @
RECTANGLE 0,0 2,2
DISPLAY
END
'
./asciidraw.out <<ENDOFCMDS
GRID 20 20
RECTANGLE 15,15 2,6
DISPLAY
CHAR @
RECTANGLE 0,0 2,2
DISPLAY
END
'
ENDOFCMDS

echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo


######################################################################################

echo " --- egde cases: single point shapes, truncation, etc --- "

echo
echo TEST 10
echo

#tests for one point lines, rectangles and 0 radius circles (it should give nothing)
#tests for typos in commands and situations where the GRID as not been set yet
#Makes sure END command ends program properly 

echo '
CIRLCEE 10,10 100
RECANGLE 10,10 0,0
GRID 50 50
RECTANGLE 2,2 1,1
RECTANGLE 4,4 4,4
DISPLAY
CHAR % 
CIRCLE 10,10 0
DISPLAY
CIRCLEE 40,40 20
LINE 015,15 15,015
LINE 15,017 016,018
CHAR #
DISPLAY
RECTANGLE 40,40 60,60
DISPLLIAY
DISPLAY
END
CHAR C
CIRCLE 10,10 40
'

./asciidraw.out <<ENDOFCMDS
CIRLCEE 10,10 100
RECANGLE 0,0 10,10
GRID 50 50
RECTANGLE 1,1 2,2
RECTANGLE 4,4 4,4
DISPLAY
CHAR % 
CIRCLE 10,10 0
DISPLAY
CIRCLEE 40,40 20
LINE 15,15 15,15
LINE 15,17 16,18
CHAR #
DISPLAY
RECTANGLE 40,40 60,60
DISPLLIAY
DISPLAY
END
CHAR C
CIRCLE 10,10 40
ENDOFCMDS

echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo

########

echo
echo TEST 11
echo

#Tests for typos in commands
#Commands before GRID
#Proper truncation of shapes
#Response to negative values (in GRID command)
#Response to no input (\n character), to makes sure program does get in a infinite loop
#Response to HUGE shapes

echo '
CIRCLE 10,10 30
CHAR %
CIRCLE 10,10 30

GRID -100, -100
GRID 40, 60 
CIRCLE 10,10 30

DISPLAY
CHAR +
LINE 0,0 100,40
DISPLAY
END
'
./asciidraw.out << ENDOFCMDS
CIRCLE 10,10 30
CHAR %
CIRCLE 10,10 30

GRID -100, -100
GRID 40, 60 
CIRCLE 10,10 30

DISPLAY
CHAR +
LINE 0,0 100,40
DISPLAY
END
ENDOFCMDS

echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo 


##########

echo
echo TEST 12
echo

#Tests to make sure segmentation fault does not happen when coordinates bigger than 1000 
#Tests for massive shapes

echo '
GRID 1000 1000
LINE 0,0 2000 1100
CHAR #
LINE -100,-100, 100,100
CHAR +
LINE -2000,500, 400,0
CHAR &
CIRCLE 500,500 6000
END
'R %
#This will be hell on your terminal 

./asciidraw.out <<ENDOFCMDS
GRID 1000 1000
LINE 0,0 2000 1100
CHAR #
LINE -100,-100, 100,100
CHAR +
LINE -2000,500, 400,0
CHAR &
CIRCLE 500,500 6000
END
'
ENDOFCMDS

#Since displaying the output of this will be unreadable
#we will instead just check that the exit code is successful
#Checks for segmentation fault in the program (makes sures we are not trying to access some piece of reserved memory)  
if [ $? == 0 ] 
then
echo --- TEST 12 ran without issues, exit code: $? ---
else
echo --- TEST 12 failed with exit code: $? ---
fi

echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo 

echo TEST 13

#this tests if program still works with MASSIVE input numbers (negative and positive)
#Shapes should be truncated but visisble on display  

echo '
GRID 200 200
CHAR 0
CIRCLE 900,100 800
CHAR #
LINE -5000,-5000 5000,5000
CHAR %
RECTANGLE 4500,-4500 100,100
DISPLAY
END
'
./asciidraw.out << ENDOFCMDS
GRID 200 200
CHAR 0
CIRCLE 900,100 800 
CHAR #
LINE -5000,-5000 5000,5000
CHAR %
RECTANGLE 4500,-4500 100,100
DISPLAY
END
ENDOFCMDS



echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo ALL TESTS CASES DONE...
