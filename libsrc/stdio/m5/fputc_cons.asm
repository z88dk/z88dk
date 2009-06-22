;
; 	Basic video handling for the SORD M5
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.4 2009-06-22 21:44:17 dom Exp $
;

	XLIB	fputc_cons
	LIB	msxbios

	INCLUDE "m5bios.def"

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	ld	ix,DSPCH
	jp	msxbios
