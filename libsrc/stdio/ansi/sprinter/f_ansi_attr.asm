;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: f_ansi_attr.asm,v 1.1 2002-10-10 20:38:22 dom Exp $
;

	XLIB	ansi_attr

	XDEF	text_attr

; 0 = reset all attributes
; 1 = bold on
; 2 = dim
; 4 = underline
; 5 = blink on
; 7 = reverse on
; 8 = invisible (dim again?)
; 8 = tim off
; 24 = underline off
; 25 = blink off
; 27 = reverse off
; 28 = invisible off
; 30 - 37 = foreground colour
; 40 - 47 = background colour
.ansi_attr
	and	a
	jr	nz,noreset
	ld	a,15
	ld	(text_attr),a
	ret
.noreset
	cp	2
	jr	z,dim
	cp	8
	jr	nz,nodim
.dim
	ld	a,(text_attr)
	and	@01110111
	ld	(text_attr),a
	ret
.nodim
	cp	7
	jr	z,switchreverse
	cp	27
	jr	nz,noreverse
.switchreverse
	ld	a,(text_attr)
	add	a
	add	a
	add	a
	add	a
	and	@11110000
	ld	e,a
	ld	a,(text_attr)
	rrca
	rrca
	rrca
	rrca
	and	@0001111
	or	e
	ld	(text_attr),a
	ret

.noreverse
	cp	30
	ret	m
	cp	37+1
	jp	p,background
	sub	30
	ld	e,a
	ld	a,(text_attr)
	and	@11111000
	or	e
	ld	(text_attr),a
	ret
.background
	cp	47+1
	ret	p
	sub	40
	add	a,a
	add	a,a
	add	a,a
	ld	e,a
	ld	a,(text_attr)
	and	@10001111
	or	e
	ld	(text_attr),a
	ret

.text_attr	defb	15
