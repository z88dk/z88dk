;
;	Far Call for REX6000
;
;	WritePar1 function to write a parameter to a save place
;	Daniel
;
;       $Id: wrpar1.asm,v 1.1 2002-01-18 12:06:40 dom Exp $


		XLIB	wrpar1
		XREF	far_par1


.wrpar1
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	(far_par1),hl
	ret



