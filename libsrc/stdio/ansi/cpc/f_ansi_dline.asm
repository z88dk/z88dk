;
; 	ANSI Video handling for the Amstrad CPC
;
; 	Clean a text line
;
;	Stefano Bodrato - Jul. 2004
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.4 2015-01-19 01:33:18 pauloscustodio Exp $
;


        PUBLIC	ansi_del_line

        INCLUDE "cpcfirm.def"

.ansi_del_line
        ld      a,$11
        call    firmware
        defw    txt_output
        ld      a,$12
        call    firmware
        defw    txt_output
        ret

