;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;

        XLIB	ansi_SCROLLUP

        INCLUDE "cpcfirm.def"
        XREF	text_rows


.ansi_SCROLLUP
        ld      a,50
        call    firmware
        defw    txt_set_row
        ld      a,10
        call    firmware
        defw    txt_output
        ret
 
 