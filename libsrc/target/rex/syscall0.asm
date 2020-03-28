;
;	System Call for REX6000
;
;	$Id: syscall0.asm,v 1.4 2015-01-19 01:33:06 pauloscustodio Exp $

		PUBLIC	syscall0


.syscall0
	pop	bc
	pop	hl	;parameter
	push	hl
	push	bc
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	ret


