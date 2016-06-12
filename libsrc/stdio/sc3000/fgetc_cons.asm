;
;   SEGA SC-3000 C Library
;
;	getkey() Wait for keypress
;
;	$Id: fgetc_cons.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
	call	$42D4
	ld	l,a
	ld	h,0
	ret
