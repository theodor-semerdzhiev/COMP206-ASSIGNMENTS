//Theodor Semerdzhiev
//McGill ID: 261118892
//Faculty of Science 


#include <stdio.h>
#include <string.h>
#include <math.h>

int main() {

char wholecommand[100];
char whlcommandcp1[100];
char display[100]; //Used to display whole line if command does not exist
int param_arr[100]; //stores proper int parameters from commands 
char *command;

char canvas_arr[1000][1000]; //--> [Y][X]

int gridset= 0; //checks if grid is set, if its not ==> 0, if it is ==> 1 

char drawchar = '*'; //sets default drawing character

int gridwidth;
int gridheight;

for(;;) {
scanf(" %[^\n]%*c", wholecommand); //stores the WHOLE line (command and param) into wholecommand
//the space in scanf prevents an infinite loop, when the only input is \n (enter)



strcpy(whlcommandcp1,wholecommand); //Copies wholecommand string to whlcommandcp1, since strtok() modifies the string that you input
strcpy(display,wholecommand); //Copies wholecommand string to display since we need to save it to display to screen

command=strtok(whlcommandcp1, " "); //gets the command that we want to execute 

char *param_arr_unformatted[100];//used to get parameters of command, to be converted to integer later 
char *p = strtok(wholecommand, " ,"); 
		
int count=0; 
//converts string data type INTO integer data type (assumes user inputted proper parameters i.e integer)
while(p != NULL) {  
param_arr_unformatted[count++]=p;
p = strtok(NULL, " ,");	
}
//sets those integers into an array
//except if the CHAR command is inputted, in which case the parameter must be a character, NOT an integer
if (strcmp(command,"CHAR") != 0) {
	int param;
	for(int i=1; i < count; i++) {
	sscanf(param_arr_unformatted[i], "%d", &param);
	param_arr[i]=param;
	}
}

/////////////////////////////////////////////////////////////////

	if (strcmp(command,"GRID") == 0) {
		if (gridset == 0) {
			//checks if the values inputed as parameters are valid
			if (param_arr[2] > 0 && param_arr[2] <= 1000 && param_arr[1] > 0 && param_arr[1] <= 1000) {		
			gridwidth = param_arr[1];
                        gridheight = param_arr[2];
                        gridset = 1;
			} else {
			printf("GRID WIDTH:%d and GRID HEIGHT:%d not valid\n", param_arr[1], param_arr[2]);		
			}
		} else {
		printf("GRID was already set to %d,%d.\n", gridwidth, gridheight);
		}

////////////////////////////////////////////////////////////////////

	} else if (strcmp(command,"CHAR") == 0) {
		//sets draw character
		sscanf(param_arr_unformatted[1], "%c", &drawchar);

/////////////////////////////////////////////////////////////////////

	} else if (strcmp(command,"RECTANGLE") == 0) {
		if (gridset == 1) {	
		
		//param_arr[1] ---> x1
		//param_arr[2] ---> y1
		//param_arr[3] ---> x2
		//param_arr[4] ---> y2
		
		int x_start;
		int x_dif;
		int y_start;
		int y_dif;
		
		//sets vertical starting point and rectangle width (x_dif), in a way that its always a positive int
		if(param_arr[1] > param_arr[3]) {
		x_start=param_arr[3];
		x_dif=param_arr[1]-param_arr[3];
		} else {
		x_start=param_arr[1];	
		x_dif=param_arr[3]-param_arr[1];
		} 
		//sets horizontal starting point and rectangle height (y_dif), in a way that its always a positive int
		if(param_arr[2] > param_arr[4]) {
		y_start=param_arr[4];
		y_dif=param_arr[2]-param_arr[4];
		} else {
		y_start=param_arr[2];
		y_dif=param_arr[4]-param_arr[2];
		}	
		//prints vertical lines of the rectangle			
		for(int i=0; i < x_dif+1; i++) {
			if(y_start+y_dif >= 0 && x_start+i >= 0 && y_start+y_dif <= 999 && x_start+i <= 999) {		
			canvas_arr[y_start+y_dif][x_start+i]=drawchar;
			}
			if (y_start >= 0 && x_start+i >= 0 && y_start <= 999 && x_start+i <= 999) {
			canvas_arr[y_start][x_start+i]=drawchar;
			}
		}
		//prints the horizontal line of the rectangle 
		for(int j=0; j < y_dif+1; j++) {
			if(y_start+j >= 0 && x_start+x_dif >= 0 && y_start+j <= 999 && x_start+x_dif <= 999) {
			canvas_arr[y_start+j][x_start+x_dif]=drawchar;
			}
			if(y_start+j >= 0 && x_start >= 0 && y_start+j <= 999 && x_start <= 999) {
			canvas_arr[y_start+j][x_start]=drawchar;
			}
		}		
		
		} else {
		puts("Only CHAR command is allowed before the grid size is set\n");	
		}

//////////////////////////////////////////////////////////////////////

	} else if (strcmp(command,"LINE") == 0) {
		if (gridset == 1) {
		//Refering to order of command parameters inputted by user
		//param_arr[1] ---> x1
		//param_arr[2] ---> y1
		//param_arr[3] ---> x2
		//param_arr[4] ---> y2
				
		int x1;
		int y1;
		int x2;
		int y2;
		float slope;
		float y_intercept;
		int y_current;
		int x_current;
	
		//sets the proper values for x1, x2 to calulate slope later
		if(param_arr[1] > param_arr[3]) {
		x1=param_arr[3];
		x2=param_arr[1];
		y1=param_arr[4];
		y2=param_arr[2];
		} else {
		x1=param_arr[1];
		x2=param_arr[3];	
		y1=param_arr[2];
		y2=param_arr[4];
		} 
	
		//checks for base cases (if line fully horizontal or vertical)
		if ((double)x2-(double)x1 == 0) {
			for (int i=y1; i<y2+1; i++) {
				if(i >=0 && x1 >= 0 && i <=999 && x1 <= 999) {
				canvas_arr[i][x1]=drawchar;
				}
			}
			continue;
		} else if ((double)y2-(double)y1==0) {
			for (int i=x1; i < x2+1; i++) {
				if(y1 >=0 && i >= 0 && y1 <=999 && i <= 999) {
				canvas_arr[y1][i]=drawchar;
				}
			}
			continue;
		} else {
		
		slope = ((double)y2-(double)y1)/((double)x2-(double)x1);
		y_intercept = y1-(slope*x1);
		y_current=y1;
		x_current=x1;

		
		float exact_y;	
		//if the line is going up
		if (slope > 0) {	
			for(int i=x1; i<=x2; i++) {
				exact_y= (slope*i)+y_intercept;
				for(int j=y_current; j <= floor(exact_y); j++) { 
					if (j >= 0 && i >= 0 && j <= 999 && i <= 999) {
					canvas_arr[j][i]=drawchar;
					}
				}
				y_current=floor(exact_y);
			}
				
		//if the line is going down
		} else if (slope < 0) {	
			for(int i=x1; i<=x2; i++) {
				exact_y= (slope*i)+y_intercept;
				for(int j=0; j <= y_current-floor(exact_y); j++) { 
					if (y_current-j >= 0 && i >= 0 && y_current-j <= 999 && i <= 999) {
					canvas_arr[y_current-j][i]=drawchar;
					}
				}
				y_current=floor(exact_y);
			}
		} 
		}
		} else {
		puts("Only CHAR command is allowed before the grid size is set\n");
		}

/////////////////////////////////////////////////////////////////////

	} else if (strcmp(command,"CIRCLE") == 0) {
		if (gridset == 1) {


		int radius=param_arr[3]-1;
		int x1=param_arr[1];
		int y1=param_arr[2];
		int y_current=y1+radius;
		float exact_y;
		
		//Prints circle (stores characters into canvas array
		for(int i=0; i<=radius; i++) {
		int j=0;
		exact_y=sqrt(pow(radius,2)-pow(i,2))+(double)y1;
			do {
				if(i==0) {break;} //this is fine tuning to make the circle as symmetric as possible

				//prints top half of circle
				if(y_current-j >= 0 && x1+i >= 0 && y_current-j <= 999 && x1+i <= 999) {
				canvas_arr[y_current-j][x1+i]=drawchar;
				}
				if(y_current-j >= 0 && x1-i >= 0 && y_current-j <= 999 && x1-i <= 999) {
				canvas_arr[y_current-j][x1-i]=drawchar;
				}

				//prints second half of circle
				if(y1-(y_current-y1)+j >= 0 && x1+i >= 0 && y1-(y_current-y1)+j <= 999 && x1+i <= 999) {
				canvas_arr[y1-(y_current-y1)+j][x1+i]=drawchar;
				}
				if(y1-(y_current-y1)+j >= 0 && x1-i >= 0 && y1-(y_current-y1)+j <= 999 && x1-i <= 999) {
				canvas_arr[y1-(y_current-y1)+j][x1-i]=drawchar;	
				}	
				//printf("y_current=%d\n", y_current); //for debugging purposes
				j++;
			} while(j < y_current-floor(exact_y)); 
				y_current=round(exact_y);
			}
		
			//Fills in the the tips
			if(y1+radius+1 >= 0 && x1 >= 0 && y1+radius+1 <= 999 && x1 <= 999) {
			canvas_arr[y1+radius+1][x1]=drawchar;
			}
			if(y1 >= 0 && x1+radius+1 >= 0 && y1 <= 999 && x1+radius+1 <= 999) {			
			canvas_arr[y1][x1+radius+1]=drawchar;
			}
			if(y1-radius-1 >= 0 && x1 >= 0 && y1-radius-1 <= 999 && x1 <= 999) {
			canvas_arr[y1-radius-1][x1]=drawchar;
			}
			if(y1 >=0 && x1-radius-1 >= 0 && y1 <=999 && x1-radius-1 <= 999) {
			canvas_arr[y1][x1-radius-1]=drawchar;
			}
			

		} else {
		puts("Only CHAR command is allowed before the grid size is set\n");
		}

/////////////////////////////////////////////////////////////////////

	} else if(strcmp(command,"DISPLAY") == 0) {
		if(gridset == 1) {
			for(int i=0; i < gridheight; i++) {
			//prints the i th vertical axis number
			printf("%d", (gridheight-i-1) % 10);
				//prints contents of canvas array visible in the grid dimensions
				for(int j=0; j < gridwidth; j++) {
					if(canvas_arr[gridheight-1-i][j]=='\0') {
					printf(" ");
					} else {
					printf("%c", canvas_arr[gridheight-1-i][j]);	
					}
				}
			printf("\n");
			}
			//Prints the horizontal axis
			for(int i=-1; i < gridwidth; i++) {
			if(i == -1) {
			printf(" ");
			continue;
			}
			if(i == gridwidth) {
			break;
			}
			printf("%d", i % 10);
			}
			printf("\n");
		} else {
		puts("Only CHAR command is allowed before the grid size is set\n");
		}

////////////////////////////////////////////////////////////////////

	} else if(strcmp(command, "END") == 0) { //Checks if the command is END, in which case we end the program		
		break;	

///////////////////////////////////////////////////////////////////
	
	} else {
		printf("ERROR did not understand %s\n", display);
	}
}
return 0;
}
