;--------------------------------------------------------------
; ZX81 HRG library for the G007 expansion
; by Stefano Bodrato, Fall 2014
;--------------------------------------------------------------
;
;   Set HRG mode and clear screen
;
;	$Id: g007_clg_hr.asm,v 1.4 2015-01-19 01:32:52 pauloscustodio Exp $
;

	PUBLIC    _clg_hr
	EXTERN     hrg_on

;	XREF    base_graphics	
;	XREF    G007_P2


._clg_hr

	jp	hrg_on

;; if hrgpage has not been specified, then set a default value
;	ld      hl,(base_graphics)
;	ld      a,h
;	or      l
;	jr		nz,gotpage
;	ld		hl,24600		; on a 16K system we leave a space of a bit more than 1500 bytes for stack
;	ld		(base_graphics),hl
;gotpage:
;	
;	ld		hl,(base_graphics)
;	ld		de,9
;	add		hl,de
;	
;	ld		a,$76	; NEWLINE (HALT in machine code)
;	ld		(hl),a
;	inc		hl
;	ld		(hl),a
;	inc		hl
;	
;	
;	ld		(hl),0
;	ld		d,h
;	ld		e,l
;	inc 	de
;	ld		bc,34*192+4
;	ldir
;
;	ld		(hl),a	; NEWLINE (HALT in machine code)
;	inc		hl
;	ld		(hl),a
;	
;	ld		a,(G007_P2+2)
;	cp		193
;	jp		nz,hrg_on
;	
;	ret

