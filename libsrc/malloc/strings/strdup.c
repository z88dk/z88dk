/*
 *	z88dk Standard library
 *
 *	char *strdup(s1)
 *	Duplicate a string in memory
 *
 *	This requires linking with a malloc library
 *
 * -----
 * $Id: strdup.c,v 1.2 2001-04-18 14:59:40 stefano Exp $
 */

#include <stdlib.h>
#include <string.h>


char *strdup(char *orig)
{
	char *ptr;


	ptr=malloc(strlen(orig) + 1);

	if (ptr) {
		strcpy(ptr,orig);
	}
	return (ptr);
}


