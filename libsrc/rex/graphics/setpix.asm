;
;	written by Waleed Hasan
;
;	$Id: setpix.asm,v 1.3 2015-01-19 01:33:06 pauloscustodio Exp $
;

	PUBLIC	setpix
	EXTERN	pixaddr
	
;
; direct LCD pixel plot
; ASM entry point
;
; i/p	: D=x		E=y
; uses	: AF,BC,HL,DE
;
.setpix

;	in	a,(3)
;	ld	l,a
;	in	a,(4)
;	ld	h,a
;	push	hl

	ld	a,$10
	out	(4),a
	xor	a
	out	(3),a

	call	pixaddr
	ld	a,c
	or	(hl)
	ld	(hl),a
	
;	pop	hl
;	ld	a,l
;	out	(3),a
;	ld	a,h
;	out	(4),a
	
	ret
