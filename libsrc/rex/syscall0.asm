;
;	System Call for REX6000
;
;	$Id: syscall0.asm,v 1.2 2001-09-03 16:13:20 dom Exp $

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


