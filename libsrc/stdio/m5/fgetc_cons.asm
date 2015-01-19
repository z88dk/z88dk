;
;	SORD M5 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.5 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons
	EXTERN	msxbios

	INCLUDE "m5bios.def"

.fgetc_cons
	ld	ix,ACECHI
	call	msxbios
	ld	h,0
	ld	l,a
	ret
