;
;	Amstrad CPC Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fgetc_cons.asm,v 1.3 2007-07-21 21:28:22 dom Exp $
;

        XLIB	fgetc_cons
        
        INCLUDE "#cpcfirm.def"
        
        
.fgetc_cons
        call    firmware
        defw    km_wait_char
        ld      h,0
        ld      l,a
        ret

