/*
 *	int atoi (char *)
 *
 *	Convert ascii string to integer...
 *
 *	equivalent to stroul(ptr,NULL,10)
 *
 *	But this should be shorter...
 *
 *	Almost k&r but not quite..
 *
 *	djm 5/1/2000
 */

#include <ctype.h>
#include <stdlib.h>

int atoi(char *s)
{
	int sign;
	int n;
	unsigned char *ptr;

	ptr=s;
	while (isspace(*ptr) ) ++ptr;

	sign = (*ptr == '-' ) ? -1 : 1;
	if (*ptr=='+' || *ptr=='-' ) ++ptr;

	for (n=0; isdigit(*ptr); ++ptr)
		n = 10*n + (*ptr-'0');
	return sign*n;
}




