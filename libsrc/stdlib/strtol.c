/*
 *      strtol(char *ptr, char **endptr, int base)
 *
 *      Taken from vbcc archive
 *
 *      27/4/99 djm
 *
 * -----
 * $Id: strtol.c,v 1.2 2001-04-18 12:43:04 stefano Exp $
 *
 */



#include <stdio.h>
#include <ctype.h>
#include <limits.h>
#include <stdlib.h>


signed long strtol(
char *nptr,
char **endptr,
int base)
{ 

  unsigned long r;
  unsigned char *q;
  unsigned char *p;

  p=nptr;

  while(isspace(*p))
    p++;
  r=strtoul(p,(signed char **)&q,base);
  if(endptr!=NULL)
  { if(q==p)
      *endptr=(char *)nptr;
    else
      *endptr=q;
  }
  if(*p=='-') {
    if((signed long)r>0)
      return LONG_MIN;
    else
      return r;
  } else {
   if((signed long)r<0)
      return LONG_MAX;
    else
      return r;
  }
}
