/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: sleep.c,v 1.2 2012-05-16 16:59:56 stefano Exp $
 */

#include <stdlib.h>
#include <time.h>


void sleep(int secs)
{
#ifndef __Z88__

    long start = clock();  
	long per   = secs * CLOCKS_PER_SEC;
        
        while ( (clock() - start) < per )
                ;

#else

#asm
	INCLUDE "time.def"

	LIB	l_mult
	LIB	l_div_u

	ex de,hl	; __FASTCALL__ put number of seconds in HL
    
	ld	hl,100
	call	l_mult
	ld	c,l
	ld	b,h
        call_oz(os_dly)
	ld	hl,0
	ret	nc	;NULL - normal
; Now found out how long is left to sleep for..
	ld	e,c
	ld	d,b
	ld	hl,100
	call	l_div_u
	ld	c,l
	ld	b,h
#endasm

#endif
}

