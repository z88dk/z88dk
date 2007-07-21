;
;	Amstrad CPC Stdio
;
;	putchar - puts a character
;	(HL)=char to display
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fputc_cons.asm,v 1.3 2007-07-21 21:28:22 dom Exp $
;

        XLIB	fputc_cons

        INCLUDE "#cpcfirm.def"
        

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
