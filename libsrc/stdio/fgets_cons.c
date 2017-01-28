/*
 *	Spectrum C library
 *
 *	23/1/2000 djm
 *	24/1/2003 minor fixes by chriscowley
 *
 *	This is as usual my slightly non standard gets()
 *	which takes a length argument..
 *
 * --------
 * $Id: fgets_cons.c,v 1.10 2016-04-23 08:21:02 dom Exp $
 */

#include <stdio.h>
#include <ctype.h>

extern unsigned char _cons_state;

char *fgets_cons(char *str, size_t max)
{   
   int c;
   int ptr;
   ptr=0;

   while (1) {
      c = fgetc_cons();

      if (ptr == max-1) return str;
      
      if (c == 6)
      {
         _cons_state = ! _cons_state;   // toggle CAPS LOCK
      }
      else if (c == 12 || c == 8 )
      {
	if ( ptr > 0 )
	{
           str[--ptr] = 0;
	   fputc_cons(8);
	   fputc_cons(32);
	   fputc_cons(8);
        }
      }
      else
      {
         if (_cons_state)
            c = toupper(c);
            
         str[ptr++] = c;
         str[ptr] = 0;
	 fputc_cons(c);
         if (c == '\n' || c == '\r') return str;
      }
   }
}

