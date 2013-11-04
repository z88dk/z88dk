/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: csleep.c,v 1.2 2013-11-04 08:57:56 stefano Exp $
 */

#include <stdlib.h>
#include <time.h>
#ifdef __ZX80__
#include <zx81.h>
#endif


void  csleep(unsigned int centiseconds)
{
#ifndef __Z88__
    long start = clock();  
	long per   = (long) centiseconds * CLOCKS_PER_SEC / 100;
  #ifdef __ZX80__
	gen_tv_field_init(0);
  #endif
        
        while ( (clock() - start) < per )
  #ifdef __ZX80__
			{
			  gen_tv_field();
              FRAMES++;
			}
  #else
	;
  #endif

#else

#asm
		INCLUDE "time.def"

		; __FASTCALL__ put number of centi-seconds.. in BC

		ld	b,h
		ld	c,l

        ld      a,b
        or      c
        jr      z,csleep1
        call_oz(os_dly)
        ld      hl,1
        ret     c
.csleep1
        ld      hl,0
#endasm

#endif
}

