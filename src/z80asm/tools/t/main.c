#include <stdio.h>
#include "init.h"

void main(int argc, char *argv[])
{
	int i;
	struct Module1 *mod1;
	
	mod1 = new_Module1();
	
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
		
	delete_Module1(&mod1);
}
