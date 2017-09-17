/*
 *	z88dk Standard library
 *
 *	char *strdup(s1)
 *	Duplicate a string in memory
 *
 *	This requires linking with a malloc library
 *
 *	$Id: strdup_far.c,v 1.3 2001-04-18 14:59:40 stefano Exp $
 */

#define FARDATA 1

#include <string.h>
#include <stdlib.h>


far char *strdup_far(far char *orig)
{
	far char *ptr;
	int  len;


	len=strlen(orig);
	len++;
	ptr=malloc( len );

	if (ptr) {
		strcpy(ptr,orig);
	}
	return (ptr);
}


