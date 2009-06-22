;
;	Amstrad CPC Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fgetc_cons.asm,v 1.4 2009-06-22 21:44:17 dom Exp $
;

        XLIB	fgetc_cons
        
        INCLUDE "cpcfirm.def"
        
        
.fgetc_cons
        call    firmware
        defw    km_wait_char
        ld      h,0
        ld      l,a
        ret

