;
;	System Call for REX6000
;
;

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


