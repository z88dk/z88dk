;
;	Keyboard routines for the Robotron VEB KC85/2,3,4
;
;	By Stefano Bodrato - Oct. 2016
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.1 2016-10-03 06:38:15 stefano Exp $
;

	SECTION	code_clib
	PUBLIC	fgetc_cons
	
	INCLUDE  "caos.def"

.fgetc_cons

    call PV1
    defb FNKBD

	ld	l,a
	ld	h,0
	ret
