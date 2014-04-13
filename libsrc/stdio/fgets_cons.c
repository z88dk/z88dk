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
 * $Id: fgets_cons.c,v 1.8 2014-04-13 05:53:03 aralbrec Exp $
 */

#include <stdio.h>
#include <ctype.h>

int fgets_cons(unsigned char *str, int max)
{
   static int cursor_state = 0;
   
   unsigned char c;
   int ptr;
   ptr=0;

   while (1) {
      c = fgetc_cons();

      if (ptr == max-1) return str;
      
      if (c == 6)
      {
         cursor_state = ! cursor_state;   // toggle CAPS LOCK
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
         if (cursor_state)
            c = toupper(c);
            
         str[ptr++] = c;
         str[ptr] = 0;
	 fputc_cons(c);
         if (c == '\n' || c == '\r') return str;
      }
   }
}

