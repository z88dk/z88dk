/*
 *	Spectrum C library
 *
 *	23/1/2000 djm
 *
 *	This is as usual my slightly non standard gets()
 *	which takes a length argument..
 *
 * --------
 * $Id: fgets_cons.c,v 1.3 2002-01-27 13:50:56 dom Exp $
 */

#include <stdio.h>

int fgets_cons(unsigned char *str, int max)
{
   unsigned char c;
   int ptr;
   ptr=0;

   while (1) {
      c = fgetc_cons();
      if (c == '\n' || c == '\r' || ptr == max-1) return ptr;
      if (c == 12) {
         str[--ptr] = 0;
	 fputc_cons(8);
	 fputc_cons(32);
	 fputc_cons(8);
      }
      else {
         str[ptr++] = c;
         str[ptr] = 0;
	 fputc_cons(c);
      }
   }
}

