/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: sleep.c,v 1.5 2016-07-02 14:44:33 dom Exp $
 */

#include <stdlib.h>
#include <time.h>

#ifdef __ZX80__
#include <zx81.h>

int sleep(int secs)
{
	clock_t start = clock();  
	clock_t per   = (clock_t) secs * CLOCKS_PER_SEC;
	gen_tv_field_init(0);

    while ((clock() - start) < per) {        
	    gen_tv_field();
            FRAMES++;
	}
     return 0;
}
#else
//int sleep(int secs) __z88dk_fastcall __naked
static void __private_wrapper() __naked
{
#asm
	PUBLIC	_sleep
_sleep:
sleep:
	ld	a,h
	or	l
	ret	z
	push	hl
	ld	hl,1000
	call	msleep
	pop	hl
	dec	hl
	jp	sleep
#endasm
}
#endif




