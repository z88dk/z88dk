;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 29/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; Create a file
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int creat(far char *name, mode_t mode);
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: creat.asm,v 1.2 2015-01-21 08:09:27 stefano Exp $
;

		PUBLIC	creat
		EXTERN	open
		EXTERN	close

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
