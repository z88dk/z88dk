;
;	System Call for REX6000
;
;	$Id: syscall1p.asm,v 1.1 2001-07-24 07:20:49 dmarion Exp $
;

		XLIB	syscall1p


.syscall1p
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


