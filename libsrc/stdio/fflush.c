/*
 *	fflush(fp)
 *
 *	Only really valid for TCP net connections
 *
 * --------
 * $Id: fflush.c,v 1.4 2016-03-06 21:36:52 dom Exp $
 */

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>


int fflush(FILE *fp)
{
#asm
IF __CPU_R2KA__ | __CPU_R3K__
	ld	hl,(sp + 2)
ELSE
	pop	bc
	pop	hl
	push	hl
	push	bc
ENDIF
IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !_CPU_GBZ80__
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)
	and	_IOUSE|_IOEXTRA
	cp	_IOUSE|_IOEXTRA
	jr	nz,fflush_error 	;not used
	push	ix	;save callers ix
	dec	hl
	dec	hl	;hl = fp
IF __CPU_R2KA__ | __CPU_R3K__
	ld	hl,ix
	ld	hl,(ix+fp_extra)
ELSE
	push	hl
	pop	ix
	ld	l,(ix+fp_extra)
	ld	h,(ix+fp_extra+1)
ENDIF
	ld	a,__STDIO_MSG_FLUSH
	call	l_jphl
	pop	ix	;restore callers
IF __CPU_R2KA__ | __CPU_R3K__
	bool	hl
	rr	hl
ELSE
	ld	hl,0
  IF __CPU_GBZ80__
        ld      d,h
        ld      e,l
  ENDIF
ENDIF
	ret
ENDIF
.fflush_error
	ld	hl,-1	; EOF
IF __CPU_GBZ80__
        ld      d,h
        ld      e,l
ENDIF
#endasm
}





