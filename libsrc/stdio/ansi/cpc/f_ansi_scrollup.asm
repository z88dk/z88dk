;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.4 2015-01-19 01:33:18 pauloscustodio Exp $
;

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
 
 