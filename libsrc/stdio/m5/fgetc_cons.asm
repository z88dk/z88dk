;
;	SORD M5 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.6 2016-06-12 17:00:21 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	EXTERN	msxbios

	INCLUDE "m5bios.def"

.fgetc_cons
	ld	ix,ACECHI
	call	msxbios
	ld	h,0
	ld	l,a
	ret
