;
;	Amstrad CPC Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: getk.asm,v 1.3 2007-07-21 21:28:22 dom Exp $
;

        XLIB	getk

        INCLUDE "#cpcfirm.def"


.getk
        call    firmware
        defw    km_read_char
        ld      hl,0
        ret     nc
        ld      l,a
        ret
