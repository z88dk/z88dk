;
;	System Call for REX6000
;
;

		XLIB	syscall1


.syscall1
	pop	bc
	pop	hl	;call number
	pop	de	;parameter
	push	de
	push	hl
	push	bc
	ld	($c000),hl
	ld	($c002),de
	rst	$10
	ld	hl,($c00e)
	ret


