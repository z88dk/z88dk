;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.5 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
        PUBLIC	ansi_SCROLLUP

        INCLUDE "cpcfirm.def"
        EXTERN	text_rows


.ansi_SCROLLUP
        ld      a,50
        call    firmware
        defw    txt_set_row
        ld      a,10
        call    firmware
        defw    txt_output
        ret
 
 
