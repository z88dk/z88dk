;
;	Amstrad CPC Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fgetc_cons.asm,v 1.6 2016-05-19 20:51:01 dom Exp $
;

        PUBLIC	fgetc_cons
        
        INCLUDE "cpcfirm.def"
        
        
.fgetc_cons
        call    firmware
        defw    km_wait_char
        ld      h,0
        ld      l,a
	cp	127
	ret	nz
	ld	l,12
        ret

