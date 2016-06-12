;
;	SORD M5 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.7 2016-06-12 17:07:44 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons
	EXTERN	msxbios

	INCLUDE "m5bios.def"

.fgetc_cons
._fgetc_cons
	ld	ix,ACECHI
	call	msxbios
	ld	h,0
	ld	l,a
	ret
