;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 29/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; close an open file
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int close(int handle);
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: close.asm,v 1.3 2015-01-22 12:09:57 stefano Exp $
;

	PUBLIC	close
	
	EXTERN	nbhandl
	EXTERN	nb_close

.close
	pop	bc
	pop	hl
	push	hl
	push	bc
	
	push	hl
	call	nb_close
	pop	hl

	ld	de,100		; we use stream numbers startimg from 100
	add	hl,de

	ld	de,nbhandl
	xor	a
	add	hl,de
	ld	(hl),a		; free flag for handle

	ld	hl,0
	
	ret
