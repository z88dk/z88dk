/*
 *	time_t time(time_t *)
 *
 *	Return number of seconds since epoch
 *
 *	Our epoch is the UNIX epoch of 00:00:00 1/1/1970
 *
 * --------
 * $Id: time.c,v 1.4 2013-03-03 23:51:11 pauloscustodio Exp $
 */


#include <time.h>

#define JD0101970	2440588

long gtoy();

time_t time(time_t *store)
{
	long    days;
	time_t	tim;

	days = (gtoy() - JD0101970)*86400;

	tim=days+(clock()/CLOCKS_PER_SEC);

	if (store) *store=tim;

	return (tim);
}

/* Get Julian day */
long gtoy()
{
#asm
	INCLUDE	"time.def"
	ld	de,2
	call_oz(gn_gmd)	;abc, a=MSB
	ld	d,0
	ld	e,a
	ld	h,b
	ld	l,c
#endasm
}

