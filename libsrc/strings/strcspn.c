/*
 *      Small C+ String Library
 *
 *      Taken from vbcc archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 *
 *	$Id: strcspn.c,v 1.2 2001-04-11 12:15:32 dom Exp $
 */

#include <string.h>

strcspn(unsigned char *s1,unsigned char *s2)
{
    int n;
    n=0;
    while(*s1&&!strchr(s2,*s1++)) n++;
    return(n);
}
