;
;       SAM Coupe C Library
;
;	getkey() Wait for keypress
;
;       We will corrupt any register
;
;       Stefano Bodrato - Mar.2001
;
;
;	$Id: fgetc_cons.asm,v 1.4 2016-06-12 17:32:01 dom Exp $
;


        SECTION code_clib

	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
		call	$016C

		ld	h,0
		ld	l,a

		ret
