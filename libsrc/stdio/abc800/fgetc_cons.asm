;
;	ABC800 Routines
;
;	getkey() Wait for keypress
;
;	Oct. 2007 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.3 2016-06-12 17:00:21 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons

.fgetc_cons
	call	2

	ld	l,a
	ld	h,0
	ret
