/*
 *      Small C+ String Library
 *
 *      Taken from vbcc archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */

#include <string.h>

char *strpbrk(unsigned char *s3,unsigned char *s2)
{
    unsigned char *s1;
    s1=s3;
    while(*s1) if(strchr(s2,*s1)) return(s1); else ++s1;
    return(0);
}
