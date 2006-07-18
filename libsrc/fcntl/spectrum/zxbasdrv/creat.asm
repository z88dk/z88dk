;
; Create a file by the BASIC driver (open then close)
;
; Stefano - 5/7/2006
;
; int creat(far char *name, mode_t mode);
;
; $Id: creat.asm,v 1.1 2006-07-18 21:02:54 stefano Exp $

		XLIB	creat
		LIB	open
		LIB	close

.creat
	pop	bc
	pop	hl
	push	hl
	push	bc
	
	push	bc
	push	bc
	push	hl
	call	open
	pop	bc
	pop	bc
	pop	bc
	
	ld	a,h
	or	l
	cp	255	; -1 => error ?
	ret	z
	
	push	hl
	call	close
	pop	hl
	
	ld	hl,0
	ret
