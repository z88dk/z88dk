;
;	System Call for REX6000
;
;	$Id: syscall0.asm,v 1.3 2002-04-17 21:30:25 dom Exp $

		XLIB	syscall0


.syscall0
	pop	bc
	pop	hl	;parameter
	push	hl
	push	bc
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	ret


