;
;	Far Call for REX6000
;
;	FarRestore function to restore stack
;	Daniel
;
;	$Id: farres.asm,v 1.1 2001-09-03 16:13:20 dom Exp $

		XLIB	farres
		XREF	far_ret_sp


.farres
	pop	bc
	ld	hl,(far_ret_sp)
	ld	sp,hl
	push	bc
	ret
	



