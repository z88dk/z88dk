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
; $Id: ozkeyhit.asm,v 1.1 2003-10-22 13:55:49 stefano Exp $
;


	XLIB	ozkeyhit
	
	XREF	KeyBufGetPos
	XREF	EnableKeyboard


ozkeyhit:
    ld  de,EnableKeyboard
    ld  a,(de)
    and 0ffh-7
    ld  (de),a

    ld  hl,KeyBufGetPos
    ld  a,(hl)
    inc hl      ;; KeyBufPutPos
    cp  (hl)
    ld  hl,1
    ret nz
    dec hl
    ret

