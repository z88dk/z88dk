/*
 * 	Xircom REX 6000 Library
 *
 *	Wrapper function for printf etc
 *
 *	$Id: DsPrintf.c,v 1.2 2001-06-23 19:48:38 dom Exp $
 */

#include <string.h>
#include <DataSlim.h>

int DsPrintf(int x, int y, int dummy, char *format)
{
	char	buffer[80];
	strcpy(buffer,format);
	return (SYSCALLEX(0x330,x,y,-1,dummy,buffer,0));
}

