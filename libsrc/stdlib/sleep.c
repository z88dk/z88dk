/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: sleep.c,v 1.3 2013-11-04 08:57:56 stefano Exp $
 */

#include <stdlib.h>
#include <time.h>
#ifdef __ZX80__
#include <zx81.h>
#endif


void sleep(int secs)
{
#ifndef __Z88__
    long start = clock();  
	long per   = secs * CLOCKS_PER_SEC;
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

