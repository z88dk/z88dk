;
;	System Call for REX6000
;
;	$Id: syscall1.asm,v 1.6 2015-01-19 01:33:06 pauloscustodio Exp $
;

		PUBLIC	syscall1


.syscall1
	pop	bc
	pop	de	;parameter
	pop	hl	;call number
	push	hl
	push	de
	push	bc
	ld	($c000),hl
	ld	($c002),de
	rst	$10
	ld	hl,($c00e)
	ret


