/*
 *	Routine to select a file number to open a file with
 *	
 *	+3DOS has 15 available file handles and we *have*
 *	to specify which one we want
 *
 *	djm 17/3/2000
 */

#include <spectrum.h>

/* One bit per file */

int hand_status;

int findhand()
{
#asm
	ld	de,1
	ld	c,0
	ld	hl,(_status)
	ld	b,16
.loop
	srl	h	;Shift flags one bit right
	rr	l
	jr	nc,gotone
	and	a
	rl	e	;Shift mask one bit left
	rl	d
	inc	c	;Increment file number
	djnz	loop
	ld	hl,-1	;No more!
	scf
	ret
; We've found a free handle - hurrah!
.gotone
	call	hl,(_status)
	call	l_or	;Mark as used
	ld	(_status),hl
	ld	l,c
	ld	h,0
	and	a
	ret
#endasm
}


	

