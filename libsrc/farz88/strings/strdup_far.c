/*
 *	z88dk Standard library
 *
 *	char *strdup(s1)
 *	Duplicate a string in memory
 *
 *	This requires linking with a malloc library
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


