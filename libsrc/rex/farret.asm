;
;	Far Call for REX6000
;
;	FarReturn function to return from code in other mem pages
;	Daniel
;
;	$Id: farret.asm,v 1.1 2001-09-03 16:13:20 dom Exp $

		XLIB	farret
		XREF	far_ret
		XREF	far_ret_p


.farret
	pop	bc
	ld	a,(far_ret_p)
	ld	hl,(far_ret)
	call	$59ca



