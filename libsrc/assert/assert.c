/*
 *	l_assert(int, char *, char *)
 *
 *	djm 28/2/2000
 *
 *	Untested..but what could go wrong?!?!
 *
 *	$Id: assert.c,v 1.2 2001-04-17 08:05:14 stefano Exp $
 */


#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

void l_assert(int line, char *file, char *expr)
{
	fprintf(stderr,"Assertion failed: %s %d \"%s\"\n",file,line,expr);
	abort();
}

