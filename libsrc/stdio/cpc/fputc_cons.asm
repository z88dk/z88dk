;
;	Amstrad CPC Stdio
;
;	putchar - puts a character
;	(HL)=char to display
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fputc_cons.asm,v 1.6 2016-05-15 20:15:45 dom Exp $
;

	SECTION	code_clib
        PUBLIC	fputc_cons_native

        INCLUDE "cpcfirm.def"
        

.fputc_cons_native
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
IF STANDARDESCAPECHARS
        cp      10
ELSE
	cp	13
ENDIF
        jr      nz,nocr
        call    firmware
        defw    txt_output
IF STANDARDESCAPECHARS
	ld	a,13
ELSE
        ld      a,10
ENDIF
.nocr   call    firmware
        defw    txt_output
        ret
