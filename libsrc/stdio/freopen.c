/*
 * freopen.c - open a stream
 *
 * This sets up a temporary buffer then calls the real stuff
 * in freopen_z88
 *
 * djm 1/4/2000
 *
 */

#define ANSI_STDIO

#include        <stdio.h>

FILE *freopen(far char *name, unsigned char *mode, FILE *fp)
{
	char	buf[10];

	return (freopen_z88(name,mode,fp,buf,9));
}
