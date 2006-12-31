;/*
; *      strtol(char *ptr, char **endptr, int base)
; *
; *      Taken from vbcc archive
; *
; *      27/4/99 djm
; *
; * -----
; * $Id: strtoul.asm,v 1.5 2006-12-31 22:13:19 aralbrec Exp $
; *
; */

; rewritten in asm and lost the overflow check in process
; 12.2006 aralbrec
;
; Note: The writeendp subroutine expects to find the
;  char **endp pointer on the stack so this function
;  should be called using the C convention only.
;
; Uses all registers except a',iy (does use f')

XLIB strtoul
LIB strtol

.strtoul

   jp strtol

; Q: What's the difference betweem strtoul and strtol? 
; A: Just the overflow check and we'll have none of that here


;#include <stdio.h>
;#include <ctype.h>
;#include <limits.h>
;#include <stdlib.h>
;
;
;unsigned long strtoul(char *nptr,char **endptr,int base)
;{ 
;
;  unsigned char c;
;  unsigned long r;
;  unsigned char *p,*q;
;  int	a;
;  p=nptr;
;  c=0;
;  r=0L;
;
;  if(base<0||base==1||base>36)
;  { if(endptr!=NULL)
;      *endptr=(char *)nptr;
;    return 0;
;  }
;
;  while(isspace(*p))
;    p++;
;  if(*p=='-'||*p=='+')
;    c=*p++;
;  if(base==0)
;  { if(p[0]=='0')
;    { if(tolower(p[1])=='x'&&isxdigit(p[2]))
;      { p+=2;
;        base=16; }
;      else
;        base=8;
;    }else
;      base=10;
;  }
;  q=p;
;  for(;;)
;  { // int a;
;    if(!isalnum(*q))
;      break;
;    a=isdigit(*q) ? (*q-'0') : (tolower(*q)-('a'-10) );
;    if(a>base)
;      break;
;    if(r>(ULONG_MAX-(unsigned long)a)/base||r*base>ULONG_MAX-a)
;      r=ULONG_MAX; 
;    else
;      r=r*base+a;
;   q++;
; }
;  if(q==p) /* Not a single number read */
;  { if(endptr!=NULL)
;      *endptr=(char *)nptr;
;    return 0;
;  }
;  if(c=='-')
;    r=-r;
;  if(endptr!=NULL)
;    *endptr=(char *)q;
;  return r;
;}
