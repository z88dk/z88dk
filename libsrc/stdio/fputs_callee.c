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
	push	hl
	pop	ix
	call	asmentry
	pop	ix
	ret

.asmentry

DEFC ASMDISP_FPUTS_CALLEE = # asmentry - fputs_callee
PUBLIC ASMDISP_FPUTS_CALLEE

;	pop	hl	;ret
;	pop	ix	;fp
;	pop	de	;s
;	push	de
;	push	ix
;	push	hl
.loop
	ld	hl,1	;non -ve number
	ld	a,(de)	;*s
	and	a
	ret	z	;end of string
	ld	l,a
	ld	h,0
	inc	de	;s++
	push	de	;keep s
	push	hl	;send *s++
	push	ix	;send fp

	call	fputc_callee

	;pop	ix	;get fp back
	;pop	bc	;discard hl
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
