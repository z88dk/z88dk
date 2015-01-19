;
;	Z88dk Z88 Maths Library
;
;
;	$Id: stkequ2.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $

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

