/*
 *      Small C+ Library
 *
 *      More Memory Functions
 *
 *      Added to Small C+ 12/3/99 djm
 *
 *      This one is writ by me!
 *
 *
 *      void *calloc(int num, int size_of_type)
 *
 *      Allocate memory for num*size and clear it (set to 0)
 *
 *
 *	$Id: calloc.c,v 1.2 2001-04-18 14:59:40 stefano Exp $
 */

#include <malloc.h>
#include <string.h>


void *calloc(int num, int size)
{
        void *ptr;
        int  tsize;

        tsize=size*num;

        if ( (ptr=malloc(tsize) ) ) {
		memset(ptr,0,tsize);
        }
        return (ptr);
}


