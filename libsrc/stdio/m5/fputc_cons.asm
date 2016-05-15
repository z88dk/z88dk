;
; 	Basic video handling for the SORD M5
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.6 2016-05-15 20:15:45 dom Exp $
;

	SECTION code_clib
	PUBLIC	fputc_cons_native
	EXTERN	msxbios

	INCLUDE "m5bios.def"

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	ld	ix,DSPCH
	jp	msxbios
