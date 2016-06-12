;
; 	ANSI Video handling for the Philips VG-5000
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - 2014
;
;
;	$Id: f_ansi_bel.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
		ld      a,8
.BEL_LENGHT
        ld      b,70
        ld      c,$af
.BEL_loop
        dec     h
        jr      nz,BEL_jump
        xor     8
        out     (c),a
.BEL_FREQ_1
        ld      h,165
.BEL_jump
        dec     l
        jr      nz,BEL_loop
        xor     8
        out     (c),a
.BEL_FR_2
        ld      l,180
        djnz    BEL_loop
        ret

