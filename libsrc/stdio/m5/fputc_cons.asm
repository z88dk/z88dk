;
; 	Basic video handling for the SORD M5
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.2 2002-04-17 21:30:26 dom Exp $
;

	XLIB	fputc_cons

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	jp	$1088
