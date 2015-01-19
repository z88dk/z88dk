;
;	written by Waleed Hasan
;
;	$Id: pixaddr.asm,v 1.3 2015-01-19 01:33:06 pauloscustodio Exp $

	PUBLIC	pixaddr
	
;
; LCD memory pixel addres
; ASM - entry point
;
; i/p	: D=x		E=y
; uses	: AF,BC,HL,DE
; o/p	: HL=LCD memory byte address	C=pixel bit
.pixaddr
	ld	c,$80


	ld	a,d
	and	$07
	ld	b,a
	jr	z,SkpShft
.ShftOne
	srl	c		
	djnz	ShftOne
.SkpShft				; c = pixel bit.

	ld	a,d
	srl	a
	srl	a
	srl	a			; a = pixel byte
	
	ld	h,b
	ld	l,e			; HL = Y
	ld	d,h			; DE = Y
;
;we need to multiply Y by 30
;
	add	hl,hl			; HL = 2*Y

	add	hl,hl			; HL = 4*Y
	add	hl,hl			; HL = 8*Y
	add	hl,hl			; HL = 16*Y
	sbc	hl,de			; HL = 15*Y
	add	hl,hl			; HL = 30*Y

	ld	de,$a000
	add	hl,de
	
	ld	e,a
	ld	d,0
	add	hl,de
; hl = memory address
;  c = pixel bit

	ret
