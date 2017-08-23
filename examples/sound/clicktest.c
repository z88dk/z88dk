/*
	$Id: clicktest.c,v 1.1 2001-10-16 18:22:27 dom Exp $
*/

#include <sound.h>
#include <stdio.h>


main()
{
	int x;

	bit_open();
	
	while (1) 
	{
		printf("+");
		bit_click();
		printf("-");
		bit_click();
		printf(".");
		bit_click();
		bit_click();
	}
	
	bit_close();

}
