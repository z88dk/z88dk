;
;	Amstrad CPC Stdio
;
;	putchar - puts a character
;	(HL)=char to display
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fputc_cons.asm,v 1.5 2015-01-19 01:33:20 pauloscustodio Exp $
;

        PUBLIC	fputc_cons

        INCLUDE "cpcfirm.def"
        

.fputc_cons
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        cp      13
        jr      nz,nocr
        call    firmware
        defw    txt_output
        ld      a,10
.nocr   call    firmware
        defw    txt_output
        ret
