;
;	Far Call for REX6000
;
;	WritePar3 function to write a parameter to a save place
;	Daniel
;
;       $Id: wrpar3.asm,v 1.1 2002-01-18 12:06:40 dom Exp $


		XLIB	wrpar3
		XREF	far_par3


.wrpar3
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	(far_par3),hl
	ret

