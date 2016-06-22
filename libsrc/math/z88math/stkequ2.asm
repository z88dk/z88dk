;
;	Z88dk Z88 Maths Library
;
;
;	$Id: stkequ2.asm,v 1.3 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	stkequ2

		EXTERN	fa

; Store the FP number in FA after executing a routine

.stkequ2
        ld      (fa+3),hl
        ld      a,c
        ld      (fa+5),a
        exx
        ld      (fa+1),hl
;        xor     a
;        ld      (fa),a
        ret

