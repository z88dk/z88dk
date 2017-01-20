;
;	MicroBEE Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 2016
;
;
;	$Id: fgetc_cons.asm,v 1.1 2016-11-15 08:11:11 stefano Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
	call $803F
	jr nz,fgetc_cons
	ld	h,0
	ld	l,a
	ret
