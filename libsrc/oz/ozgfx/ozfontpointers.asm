;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	gfx functions
;
;	Font Pointers
;
; ------
; $Id: ozfontpointers.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozfontpointers

	PUBLIC	LowerFontPage1
	PUBLIC	LowerFontPage2
	PUBLIC	HigherFontPage1
	PUBLIC	HigherFontPage2
	
ozfontpointers:
        defw    Font0
        defw    Font1
        defw    Font2
        defw    Font3
        defw    Font1
        defw    Font1
        defw    Font1
        defw    Font1

Font0:  ;; PC_LARGE
LowerFontPage2:
        defb    0eh
        defb    0
        defw    0ab10h
        defw    0ab10h+310h
        defb    13
        defb    0ffh

Font1:  ;; PC_PLANE:
LowerFontPage1:
        defb    0eh
        defb    0
        defw    0a000h
        defw    0a000h+310h
        defb    8
        defb    0ffh

Font2:   ;; EO7LARGE
HigherFontPage2:
        defb    0fh
        defb    0
        defw    0ab10h
        defw    0ab10h+310h
        defb    13
        defb    0ffh

Font3:   ;; EO7PLANE:
HigherFontPage1:
        defb    0fh
        defb    0
        defw    0a000h
        defw    0a000h+310h
        defb    8
        defb    0ffh

