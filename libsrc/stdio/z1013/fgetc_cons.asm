;
;	Keyboard routines for the Robotron Z1013
;	By Stefano Bodrato - Aug. 2016
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.1 2016-08-05 07:04:10 stefano Exp $
;


		SECTION	code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons

	rst $20
	defb 1		; 'INCH' function
	and a
	jr z,fgetc_cons

	ld	l,a
	ld	h,0
	ret
