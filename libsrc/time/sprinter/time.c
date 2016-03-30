/*
 *	time_t time(time_t *)
 *
 *	Return number of seconds since epoch
 *
 *	Our epoch is the UNIX epoch of 00:00:00 1/1/1970
 *
 * --------
 * $Id: time.c,v 1.3 2016-03-30 09:20:00 dom Exp $
 */


#include <time.h>

static void gettm(struct tm *tp);

time_t time(time_t *store)
{
	struct tm tmp;
	time_t tim;

	gettm(&tmp);

	tim = mktime(&tmp);

	if ( store )
		*store = tim;

	return tim;
}

static void gettm(struct tm *tp)
{
#asm
	pop	bc
	pop	de	
	push	de
	push	bc
	push	ix	;save callers
	push	de
	ld	c,$21	;SYSTIME
	rst	$10
	pop	iy	;ick - tp pointer
	ld	(iy+0),b	;seconds
	ld	(iy+1),0
	ld	(iy+2),l	;min
	ld	(iy+3),0
	ld	(iy+4),h	;hour
	ld	(iy+5),0
	ld	(iy+6),d	;month day
	ld	(iy+7),0
	dec	e
	ld	(iy+8),e	;month
	ld	(iy+9),0
	push	ix
	pop	hl
	ld	de,1900
	and	a
	sbc	hl,de
	ld	(iy+10),l
	ld	(iy+11),h
	ld	a,c
	cp	7
	jr	nz,skip
	ld	c,0
.skip
	ld	(iy+12),c
	ld	(iy+13),0
	pop	ix		;restore callers
#endasm
}

