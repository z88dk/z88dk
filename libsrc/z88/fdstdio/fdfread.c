/*
 *	Z88 stdio library
 *
 *	fread(void *ptr,size_t size,size_t numb);
 *
 * 	djm 25/1/2000 
 *
 *	This is a major fudge and plays on the inept library
 *	for i/o of z88dk
 */

#define FDSTDIO
#include <sys/types.h>
#include <stdio.h>
#include <fcntl.h>

int fdfread(void *ptr, int size, int num, FILE *fp)
{
	if (fchkhdl(fp)) return (read((int)fp,ptr,size*num));
/* fchkhdl exits with hl=0 for bad handle.. */
}
