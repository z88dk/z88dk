;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2025
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm $
;

    SECTION code_clib
    PUBLIC  ansi_BEL
	
    EXTERN invtxt


ansi_BEL:
    call invtxt
    ld hl,8000
inv_pause:
    dec hl
	ld a,h
	or l
    jr nz,inv_pause
    jp invtxt

