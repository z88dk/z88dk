;
;	Keyboard routines for the Philips Videopac C7420
;	By Stefano Bodrato - 2015
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.3 2016-06-12 17:07:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
	call $1bdf
	or a
	jr	z,fgetc_cons
	ld h,0
	ld l,a
	ret
