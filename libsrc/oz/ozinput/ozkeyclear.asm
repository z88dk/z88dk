;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	Keyboard routines
;
; ------
; $Id: ozkeyclear.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;


	PUBLIC	ozkeyclear
	
	EXTERN	KeyBufPutPos

ozkeyclear:
        ld      hl,KeyBufPutPos
        ld      a,(hl)
        dec     hl    ;; KeyBufGetPos
        ld      (hl),a
	ret
