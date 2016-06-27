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
; $Id: ozkeyclear.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozkeyclear
	PUBLIC	_ozkeyclear
	
	EXTERN	KeyBufPutPos

ozkeyclear:
_ozkeyclear:
        ld      hl,KeyBufPutPos
        ld      a,(hl)
        dec     hl    ;; KeyBufGetPos
        ld      (hl),a
	ret
