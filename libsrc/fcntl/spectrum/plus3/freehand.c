/*
 *	Routine to free a file handle
 *	
 *	+3DOS has 15 available file handles and we *have*
 *	to specify that we which one we want
 *
 *	(Internal library routine)
 *
 *	djm 17/3/2000
 *
 *	$Id: freehand.c,v 1.1 2001-05-01 13:55:21 dom Exp $
 */

#include <spectrum.h>

/* One bit per file */

extern int hand_status;

void freehand(int handle)
{
#asm
; Enter with hl holding filehandle
; Exit: b = file handle
	ld	de,65534	
	ld	b,l
.loop
	scf
	rl	e
	rl	d
	djnz	loop
; Weve found a free handle - hurrah!
.gotone
	ld	hl,(_hand_status)
	call	l_and	;Mark as used
	ld	(_hand_status),hl
	ld	b,l
	ret
#endasm
}


	

