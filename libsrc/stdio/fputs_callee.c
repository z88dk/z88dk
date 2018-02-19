/*
 *      New stdio functions for Small C+
 *
 *	fputc handles all types
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fputs_callee.c,v 1.5 2016-03-06 21:36:52 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int fputs_callee(const char *s,FILE *fp)
{
//#ifdef Z80
#asm

	pop	bc	;ret
	pop	hl	;fp
	pop	de	;s

	push 	bc	;ret address
	push	ix	;save callers ix
IF __CPU_R2K__ | __CPU_R3K__
	ld	ix,hl
ELSE
	push	hl
	pop	ix
ENDIF
	call	asm_fputs_callee
	pop	ix
	ret

	EXTERN	asm_fputc_callee
	PUBLIC	asm_fputs_callee
; Entry:	ix = fp
;		de = s
; Exit: 	hl != 0 (success)
;		hl = -1 (failure)
.asm_fputs_callee

.loop
	ld	hl,1	;non -ve number
	ld	a,(de)	;*s
	and	a
	ret	z	;end of string
	ld	c,a
	ld	b,0
	inc	de	;s++
	push	de	;keep s
	call	asm_fputc_callee
	pop	de	;get s back
	ld	a,l	;test for EOF returned
	and	h
	inc	a
	ret	z
	jr	loop
#endasm
/*
#else
        while (*s) {
                if ( fputc(*s++,fp) == EOF) return(EOF);
        }
#endif
*/
}
