/*
 *	Open a file (stdio library) calls fopen_z88 to do
 *	the dirty work
 *
 *	Only hands r,w,a types (no modifiers)
 *
 *	djm 24/3/2000
 */

#define FDSTDIO

#include <stdio.h>
#include <fcntl.h>




FILE *zfdopen(far char *name, char *mode)
{
	char	buffer[10];	/* Temporary buffer */

	return (zfdopen_z88(name,mode,buffer,8));
}

