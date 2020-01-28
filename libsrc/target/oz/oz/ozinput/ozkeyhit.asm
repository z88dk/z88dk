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
; $Id: ozkeyhit.asm,v 1.4 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozkeyhit2	; renamed (will be redefined if used)
	PUBLIC	_ozkeyhit2	; renamed (will be redefined if used)
	
	EXTERN	KeyBufGetPos
	EXTERN	EnableKeyboard


ozkeyhit2:
_ozkeyhit2:
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

