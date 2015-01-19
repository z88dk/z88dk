;
; 	Basic video handling for the SORD M5
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.5 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	fputc_cons
	EXTERN	msxbios

	INCLUDE "m5bios.def"

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	ld	ix,DSPCH
	jp	msxbios
