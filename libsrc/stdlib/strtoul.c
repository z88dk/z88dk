/*
 *      strtoul(char *nptr, char **endptr, int base)
 *
 *      Taken from vbcc archive
 *
 *      Added to Small C+ 27/4/99 djm
 */



#include <stdio.h>
#include <ctype.h>
#include <limits.h>
#include <stdlib.h>


unsigned long strtoul(char *nptr,char **endptr,int base)
{ 

  unsigned char c;
  unsigned long r;
  unsigned char *p,*q;
  int	a;
  p=nptr;
  c=0;
  r=0L;

  if(base<0||base==1||base>36)
  { if(endptr!=NULL)
      *endptr=(char *)nptr;
    return 0;
  }

  while(isspace(*p))
    p++;
  if(*p=='-'||*p=='+')
    c=*p++;
  if(base==0)
  { if(p[0]=='0')
    { if(tolower(p[1])=='x'&&isxdigit(p[2]))
      { p+=2;
        base=16; }
      else
        base=8;
    }else
      base=10;
  }
  q=p;
  for(;;)
  { // int a;
    if(!isalnum(*q))
      break;
    a=isdigit(*q) ? (*q-'0') : (tolower(*q)-('a'-10) );
    if(a>base)
      break;
    if(r>(ULONG_MAX-(unsigned long)a)/base||r*base>ULONG_MAX-a)
      r=ULONG_MAX; 
    else
      r=r*base+a;
    q++;
  }
  if(q==p) /* Not a single number read */
  { if(endptr!=NULL)
      *endptr=(char *)nptr;
    return 0;
  }
  if(c=='-')
    r=-r;
  if(endptr!=NULL)
    *endptr=(char *)q;
  return r;
}
