/*
 * 	Xircom REX 6000 Library
 *
 *	Wrapper function for printf etc
 */

#include <string.h>
#include <DataSlim.h>

int DsPrintf(int x, int y, int dummy, char *format)
{
	char	buffer[80];
	strcpy(buffer,format);
	return (SYSCALLEX(0x330,x,y,-1,0,buffer,0));
}

