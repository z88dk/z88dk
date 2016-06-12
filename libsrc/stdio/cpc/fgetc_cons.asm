;
;	Amstrad CPC Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fgetc_cons.asm,v 1.8 2016-06-12 17:07:43 dom Exp $
;

        SECTION code_clib
        PUBLIC	fgetc_cons
        PUBLIC	_fgetc_cons
        
        INCLUDE "cpcfirm.def"
        
        
.fgetc_cons
._fgetc_cons
        call    firmware
        defw    km_wait_char
        ld      h,0
        ld      l,a
	cp	127
	ret	nz
	ld	l,12
        ret

