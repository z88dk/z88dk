/*
 *	Get Time of Year
 *
 *	(Z88 Specific, Internal Library Routine)
 *
 *	djm 13/3/2000
 *
 *	Return a long since day 0: 23/11/-4713
 */

#include <time.h>

long gtoy()
{
#asm
	INCLUDE	"#time.def"
	ld	de,2
	call_oz(gn_gmd)	;abc, a=MSB
	ld	d,0
	ld	e,a
	ld	h,b
	ld	l,c
#endasm
}

