//Theodor Semerdzhiev
//Faculty of Science
//Bachelor in Computer Software Engineering

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Record / Node for the linked list.
typedef struct PersonalInfoRecord
{ 
	char id[10];
	char ptype;
	char name[31];

	union
	{
		struct
		{
			char dept[31];
			int hireyear;
			char tenured;
		}prof;
		struct
		{
			char faculty[31];
			int admyear;
		}stud;
	}info;

	struct PersonalInfoRecord *next;
} PersonalInfoRecord;


//method to create and add/delete nodes to the linkedlist 
struct PersonalInfoRecord *updateList(char *info[], struct PersonalInfoRecord *head){ //

	// adds/removes a person to the linkedlist
	if(*info[0] == 'D') {
		
		
		struct PersonalInfoRecord *tmp = head;
		struct PersonalInfoRecord *prev = NULL;	
	
		//egde cases: if got to remove head
		if(atoi(head->id) == atoi(info[1])) {
			head=head->next;
			free(tmp);
			return head;
		}
		

		while(tmp != NULL) {
			if(atoi(tmp->id) == atoi(info[1]))  {
			prev->next = tmp->next;
			free(tmp);
			return head;
			
			//if ID being compared is smaller than the id we want to delete, we return the head, since the id is guaranteed to not be present
			} else if(atoi(tmp->id) > atoi(info[1])) {
				return head;
			}

			prev=tmp;
			tmp= tmp->next;
			
			//handles egde case where we must remove last node of list
			if(tmp == NULL && atoi(tmp->id) == atoi(info[1])) {
			prev->next=NULL;

			free(tmp);
			}
		}
		return head;	
		
	} else if(*info[0] == 'I') {

		struct PersonalInfoRecord *person = (struct PersonalInfoRecord*) malloc(sizeof(struct PersonalInfoRecord));
		
		if (*info[2] == 'P') {
			//sets the properties of the struct for a prof

			strcpy(person->id, info[1]);
		
			person->ptype = *info[2];
	
			strcpy(person->name, info[3]);
	
			strcpy(person->info.prof.dept, info[4]); 
			
			person->info.prof.hireyear = atoi(info[5]);

			person->info.prof.tenured = *info[6];	 

		} else if (*info[2] == 'S') {
			
			//sets the properties of the struct for a student 
			strcpy(person->id, info[1]);
		
			person->ptype = *info[2];
	
			strcpy(person->name, info[3]);
	
			strcpy(person->info.stud.faculty, info[4]); 
			
			person->info.stud.admyear = atoi(info[5]);

		} else {
			printf("The person type: %c, is not valid\n", *info[2]);
			free(person);
			return head;
		
		}
	
		//handles egde case where List is empty
		if(head==NULL){
			head=person;
			head->next=NULL;
			return head;
		}

		struct PersonalInfoRecord *tmp = head;
		struct PersonalInfoRecord *prev = NULL;
		
		//egde case where person must be inserted in top of list
		if(atoi(head->id) > atoi(person->id)) {
		
			person->next=head;
			head = person;
			return head; //sets new head	
		}

		while(tmp != NULL) {
			if(atoi(tmp->id) > atoi(person->id)) {
				prev->next=person;
				person->next=tmp;	
				return head;
			} 
			prev=tmp;
			tmp = tmp->next;
			//if tmp null, then looped across list, therefore must insert person at the end of the list
			if (tmp == NULL) {
			prev->next = person;
			person->next=NULL;
			return head;
			}	
		}				
	}
}

//This function returns a pointer to a formatted string containing the info of given person
char *getPersonInfo(struct PersonalInfoRecord *person, char *info){   

	char *tmp=info;
	if ((*person).ptype == 'P'){

		sprintf(tmp, "%s,%c,%s,%s,%d,%c", person->id, person->ptype, person->name, person->info.prof.dept, person->info.prof.hireyear, person->info.prof.tenured);
	} else if ((*person).ptype == 'S') {
	
		sprintf(tmp, "%s,%c,%s,%s,%d", person->id, person->ptype, person->name, person->info.stud.faculty, person->info.stud.admyear);
	}
	

	return tmp;
}

//this function takes info from stdin and changes the fields of *person
void updateRecord(char *info[], struct PersonalInfoRecord *person) { 

	//changes the name of the person	
	if(*info[3] != '\0') {
		strcpy(person->name, info[3]);
	} 
	//sets values reserved for professor type
	if (person->ptype == 'P') {
		if(*info[4] != '\0') {
			strcpy(person->info.prof.dept, info[4]);
		}
		if (*info[5] != '\0') {
			person->info.prof.hireyear = atoi(info[5]);
		}
		if (*info[6] != '\n' && *info[6] != ' ' && *info[6] != '\v' && *info[6] != '\t') {
			person->info.prof.tenured = *info[6];			
		}

	//sets values reserved for student type 
	} else if (person->ptype == 'S'){
		if(*info[4] != '\0') {
			strcpy(person->info.stud.faculty, info[4]);	
		}
		if(*info[5] != '\n' && *info[5] != ' ' && *info[5] != '\v' && *info[5] != '\t') {
			person->info.stud.admyear=atoi(info[5]);
		}
	} 
}

//returns a pointer to a person in list matching the id given as param
struct PersonalInfoRecord *inList(struct PersonalInfoRecord *head, int id) {
	struct PersonalInfoRecord *tmp = head;
	
	while(tmp != NULL) {
		if (atoi(tmp->id) == id) {
			return tmp;  
		} else {
			tmp=tmp->next;
		}
	}
	return tmp; //will return the present in List matching the ID
}


int main(int argc, char *argv[])
{
	//checks if number of paramters given are proper 
	if (argc == 1 || argc >= 3) {
	printf("Error, please pass the database filename as the only argument\nUsage: %s <dbfile>\n", argv[0]);
	return 1;
	}


	FILE *dbfile=NULL; //create files that will use to print contents of linkedlist
	char inputbuffer[100], *input=NULL; // to store each input line;
	char *info[15]; //stores pointers to fields of the nodes	
	struct PersonalInfoRecord *head=NULL; //will point to the head of linkedlist 
	
	while (fgets(input=inputbuffer, 100, stdin) != NULL) // Get each input line.
	{
		// We are asked to terminate.
		if(strncmp(input, "END", 3) == 0) {
		
			dbfile=fopen(argv[1], "w");		
			
			struct PersonalInfoRecord *tmp = head;
			struct PersonalInfoRecord *prev = NULL;
			// if cant open file, return code 3
			if(dbfile == NULL) {
				printf("Error, unable to open %s for writing\n",argv[1]);
						
				//loop used to deallocate memory in case program ends with error			
				while(tmp != NULL) {
					prev=tmp;
					tmp=tmp->next;
					free(prev); //deallocating memory
				}
				return 3;
			}	
			char info[100];

			while(tmp != NULL) {
				fprintf(dbfile,"%s\n",getPersonInfo(tmp, info));
				prev=tmp;
				tmp=tmp->next;
				free(prev); //while printing to file we deallocate memory
			}
			break;
		
		} else if(strncmp(input, "LIST", 4) == 0) {
		
			char info[100]; //100 size ensures program wont crash with longest possible strlen in stdin
			struct PersonalInfoRecord *tmp = head;

			while(tmp != NULL) {
				
				printf("%s\n", getPersonInfo(tmp, info));
				tmp = tmp->next;
			}

			continue;
		} else {
			int field=0;
			char*fielddata = strsep(&input, ",\n");
					
			//gets standard input 
			while(fielddata != NULL) {
				
				info[field++]=fielddata;
				fielddata = strsep(&input, ",");
			}
			
			//delete a node
			if(*info[0] == 'D') {

				head = updateList(info, head);

			//add or update a node
			} else if(*info[0] == 'I') {

				struct PersonalInfoRecord *tmp = inList(head, atoi(info[1]));
				
				//this means node is already in list
				if (tmp != NULL) {
					updateRecord(info, tmp); 
			
				} else {
					
					head = updateList(info, head);
				}
			}		
		}
	}
	return 0; // Appropriate return code from this program.
	
}






//Little easter egg if you had the patients to look through my perfect (almost) bulletproof code :)
