/*
 *	clock() function
 *
 *	Return the current time basically
 *	Typically used to find amount of CPU time
 *	used by a program.
 *
 *	ANSI allows any time at start of program so
 *	properly written programs should call this fn
 *	twice and take the difference
 *
 *	djm 9/1/2000
 */

#include <time.h>


/*
 * Get the current time
 */

clock_t clock()
{
#asm
	INCLUDE	"#time.def"
	ld	de,2	;FIX djm 13/3/2000 DN3.23 states de=1 is illegal
	call_oz(gn_gmt)	;abc, a=MSB
	ld	d,0
	ld	e,a
	ld	h,b
	ld	l,c
#endasm
}
