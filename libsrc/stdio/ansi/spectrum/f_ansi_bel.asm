;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	BEL - chr(7)   Beep it out
;	
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: f_ansi_bel.asm,v 1.4 2016-04-04 18:31:23 dom Exp $
;

	SECTION code_clib
	PUBLIC	ansi_BEL

; A fine double frequency beep for BEL

.ansi_BEL
        ld      a,(23624)
        rra
        rra
        rra
.BEL_LENGHT
        ld      b,70
        ld      c,254
.BEL_loop
        dec     h
        jr      nz,BEL_jump
        xor     16
        out     (c),a
.BEL_FREQ_1
        ld      h,165
.BEL_jump
        dec     l
        jr      nz,BEL_loop
        xor     16
        out     (c),a
.BEL_FR_2
        ld      l,180
        djnz    BEL_loop
        ret

