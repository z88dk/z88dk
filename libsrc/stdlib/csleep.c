/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: csleep.c,v 1.1 2012-05-16 16:59:56 stefano Exp $
 */

#include <stdlib.h>
#include <time.h>


void  csleep(unsigned int centiseconds)
{
#ifndef __Z88__


    long start = clock();  
	long per   = (long) centiseconds * CLOCKS_PER_SEC / 100;
        
        while ( (clock() - start) < per )
                ;

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

