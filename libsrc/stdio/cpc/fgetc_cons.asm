;
;	Amstrad CPC Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fgetc_cons.asm,v 1.5 2015-01-19 01:33:20 pauloscustodio Exp $
;

        PUBLIC	fgetc_cons
        
        INCLUDE "cpcfirm.def"
        
        
.fgetc_cons
        call    firmware
        defw    km_wait_char
        ld      h,0
        ld      l,a
        ret

