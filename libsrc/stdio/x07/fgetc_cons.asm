;
;	Keyboard routines for the Canon X-07
;	By Stefano Bodrato - 10/6/2011
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;


        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
	xor	a
	call $C90A
	jr	z,fgetc_cons
	ret
