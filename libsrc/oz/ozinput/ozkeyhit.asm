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
; $Id: ozkeyhit.asm,v 1.2 2003-10-27 16:56:57 stefano Exp $
;


	XLIB	ozkeyhit2	; renamed (will be redefined if used)
	
	XREF	KeyBufGetPos
	XREF	EnableKeyboard


ozkeyhit2:
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

