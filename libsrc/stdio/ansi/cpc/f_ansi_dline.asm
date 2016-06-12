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
;	$Id: f_ansi_dline.asm,v 1.5 2016-06-12 16:06:42 dom Exp $
;


        SECTION code_clib
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

