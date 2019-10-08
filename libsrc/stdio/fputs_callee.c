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

	pop	hl	;ret
	pop	bc	;fp
	pop	de	;s

	push 	hl	;ret address
IF !__CPU_INTEL__ && !__CPU_GBZ80__
	push	ix
	push	bc
	pop	ix
ENDIF
	call	asm_fputs_callee
IF __CPU_GBZ80__
    ld      d,h
    ld      e,l
ELIF !__CPU_INTEL__
	pop	ix
ENDIF
	ret

	EXTERN	asm_fputc_callee
	PUBLIC	asm_fputs_callee
; Entry:	bc = fp 
;		ix = fp on non-8080 platforms
;		de = s
; Exit: 	hl != 0 (success)
;		hl = -1 (failure)
.asm_fputs_callee

.loop
	ld	hl,1	;non -ve number
	ld	a,(de)	;*s
	and	a
	ret	z	;end of string
	inc	de	;s++
	push	de	;keep s
IF __CPU_INTEL__ || __CPU_GBZ80__
	push	bc
	ld	l,c
	ld	h,b
ENDIF
	ld	c,a
	ld	b,0
IF !__CPU_INTEL__ && !__CPU_GBZ80__
        push	ix
ENDIF
	call	asm_fputc_callee
IF !__CPU_INTEL__ && !__CPU_GBZ80__
        pop	ix
ENDIF
IF __CPU_INTEL__ || __CPU_GBZ80__
	pop	bc
ENDIF
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
