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
; $Id: ozkeyclear.asm,v 1.1 2003-10-22 13:55:49 stefano Exp $
;


	XLIB	ozkeyclear
	
	XREF	KeyBufPutPos

ozkeyclear:
        ld      hl,KeyBufPutPos
        ld      a,(hl)
        dec     hl    ;; KeyBufGetPos
        ld      (hl),a
	ret
