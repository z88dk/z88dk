;
;	Far Call for REX6000
;
;	FarRestore function to restore stack
;	Daniel
;
;	$Id: farres.asm,v 1.1 2002-01-18 12:06:40 dom Exp $


		XLIB	farres
		XREF	far_ret_sp


.farres
	pop	bc
	ld	hl,(far_ret_sp)
	ld	sp,hl
	push	bc
	ret
	



