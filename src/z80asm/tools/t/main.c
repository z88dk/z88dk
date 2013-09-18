#include <stdio.h>
#include "init.h"

int main(int argc, char *argv[])
{
	int i;
	Person *person;
	
	printf("main start\n");
	
	person = new_Person("Jack", 33);
	printf("person %s, age %d\n", person->name, person->age);
	
	printf("leak person\n");
	person = new_Person("Ripper", 34);
	printf("person %s, age %d\n", person->name, person->age);
	
	if ( argc > 1 )
	{
		printf("Hello ");
		for ( i = 1; i < argc; i++ )
		{
			printf("%s%s", argv[i], i == argc-1 ? "" : ", ");
		}
		printf("\n");
	}
	else
		printf("Hello world\n");
		
	delete_Person(&person);
	printf("person = %d\n", person);
	
	printf("main end\n");
	
	return 0;
}
