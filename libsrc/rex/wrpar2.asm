;
;	Far Call for REX6000
;
;	WritePar2 function to write a parameter to a save place
;	Daniel
;
;	$Id: wrpar2.asm,v 1.1 2001-09-03 16:13:20 dom Exp $

		XLIB	wrpar2
		XREF	far_par2


.wrpar2
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	(far_par2),hl
	ret



