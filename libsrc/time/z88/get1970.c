/*
 *	Get the machine date of the epoch (1/1/1970)
 *
 *	djm 13/3/2000
 */

#include <time.h>

time_t get1970()
{
#asm
	INCLUDE	"#time.def"

	ld	hl,dateptr
	ld	de,2		;return in abc
	ld	a,16+32		;european format
	ld	c,'/'
	ld	b,#(dateptrend-dateptr)
	call_oz(gn_gmd)
	ld	d,0
	ld	e,a
	ld	h,b
	ld	l,c
#endasm
}

#asm
.dateptr
	defm	"01/01/1970"&0
.dateptrend
#endasm

