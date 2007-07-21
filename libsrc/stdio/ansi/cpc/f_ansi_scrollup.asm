;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.2 2007-07-21 21:28:22 dom Exp $
;

        XLIB	ansi_SCROLLUP

        INCLUDE "#cpcfirm.def"
        XREF	text_rows


.ansi_SCROLLUP
        ld      a,50
        call    firmware
        defw    txt_set_row
        ld      a,10
        call    firmware
        defw    txt_output
        ret
 
 