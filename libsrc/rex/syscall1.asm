;
;	System Call for REX6000
;
;	$Id: syscall1.asm,v 1.3 2001-06-23 19:44:53 dom Exp $
;

		XLIB	syscall1


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


