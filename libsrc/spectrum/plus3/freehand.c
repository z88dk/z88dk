/*
 *	Routine to free a file handle
 *	
 *	+3DOS has 15 available file handles and we *have*
 *	to specify that we which one we want
 *
 *	(Internal library routine)
 *
 *	djm 17/3/2000
 */

#include <spectrum.h>

/* One bit per file */

extern int hand_status;

int freehand(int handle)
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
; We've found a free handle - hurrah!
.gotone
	call	hl,(_hand_status)
	call	l_or	;Mark as used
	ld	(_hand_status),hl
	ld	b,l
	ret
#endasm
}


	

