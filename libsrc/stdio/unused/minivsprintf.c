/*
 *	Generic z88dk stdio library
 *
 *	
 *	$Id: minivsprintf.c,v 1.2 2001-04-13 14:14:00 stefano Exp $
 */

#define ANSI_STDIO

#include <stdio.h>



void minivsprintf(char *str,unsigned char *a, void *b)
{
	FILE	temp;
	temp.desc.ptr=str;
	temp.flags=_IOWRITE|_IOSTRING;

        minivfprintf(temp,a,b);
	*(temp.desc.ptr)=0;
}

