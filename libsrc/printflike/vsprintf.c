/*
 *	Generic z88dk stdio library
 *
 */

#define ANSI_STDIO

#include <stdio.h>



int vsprintf(char *str,unsigned char *a, void *b)
{
	FILE	temp;
	int	ret;
	temp.desc.ptr=str;
	temp.flags=_IOWRITE|_IOSTRING;

        ret=vfprintf(temp,a,b);
	*(temp.desc.ptr)=0;
	return(ret);
}

