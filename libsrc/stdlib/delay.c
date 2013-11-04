/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: delay.c,v 1.2 2013-11-04 08:57:56 stefano Exp $
 */

#include <stdlib.h>
#include <time.h>
#ifdef __ZX80__
#include <zx81.h>
#endif


void   delay (long msecs)
{
    long start = clock();  
	long per   = msecs * CLOCKS_PER_SEC / 1000;

        while ( (clock() - start) < per )
  #ifdef __ZX80__
			{
			  gen_tv_field();
              FRAMES++;
			}
  #else
	;
  #endif
}

