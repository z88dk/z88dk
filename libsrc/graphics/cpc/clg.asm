;
;       Clear Graphics Screen
;
;       Amstrad CPC version by Stefano Bodrato  15/6/2001
;
;
;	$Id: clg.asm,v 1.9 2016-06-19 21:10:08 dom Exp $
;


        SECTION   code_clib
        PUBLIC    clg
        PUBLIC    _clg

        INCLUDE "cpcfirm.def"
        
        INCLUDE	"graphics/grafix.inc"

; Possible colors: 0 (blue), 1 (yellow), 2 (cyan), 3 (red)
;
;

.clg
._clg
        ld      a,bcolor
        call    firmware
        defw    gra_set_paper
        ld      a,fcolor
        call    firmware
        defw    gra_set_pen

	; gra_clear_window needs colors to be set, 
	; scr_clear forces default (cyan on blue)
	
        call    firmware
        defw    scr_clear	        
        ret
