/*
 *      Small C+ String Library
 *
 *      Taken from vbcc archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */

#include <string.h>

int strspn(unsigned char *s1,unsigned char *s2)
{
    int n;
    n=0;
    while(*s1&&strchr(s2,*s1++)) n++;
    return(n);
}
