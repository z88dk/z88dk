/*
 *      New stdio functions for Small C+
 *
 *	$Id: gets.c,v 1.1 2003-01-26 17:39:48 dom Exp $
 */

#define ANSI_STDIO
#include <stdio.h>

char *gets(unsigned char *str)
{
   unsigned char c;
   int ptr;
   ptr=0;

   while (1) {
      c = fgetc_cons();

      if (c == '\n' || c == '\r') return str;
      if (c == 12 || c == 8 ) {
	if ( ptr > 0 ) {
           str[--ptr] = 0;
	   fputc_cons(8);
	   fputc_cons(32);
	   fputc_cons(8);
        }
      } else {
         str[ptr++] = c;
         str[ptr] = 0;
	 fputc_cons(c);
      }
   }
}

