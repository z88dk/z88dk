;
; 	ANSI Video handling for the MicroBEE
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - 2016
;
;
;	$Id: f_ansi_bel.asm,v 1.2 2016-11-17 09:39:03 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_BEL

; A fine double frequency beep for BEL

.ansi_BEL
        xor a
.BEL_LENGHT
        ld      b,70
        ld      c,2
.BEL_loop
        dec     h
        jr      nz,BEL_jump
        xor     64
        out     (c),a
.BEL_FREQ_1
        ld      h,165
.BEL_jump
        dec     l
        jr      nz,BEL_loop
        xor     64
        out     (c),a
.BEL_FR_2
        ld      l,180
        djnz    BEL_loop
        ret

