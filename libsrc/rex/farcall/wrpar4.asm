;
;	Far Call for REX6000
;
;	WritePar4 function to write a parameter to a save place
;	Daniel
;
;       $Id: wrpar4.asm,v 1.1 2002-01-18 12:06:40 dom Exp $


		XLIB	wrpar4
		XREF	far_par4


.wrpar4
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	(far_par4),hl
	ret

