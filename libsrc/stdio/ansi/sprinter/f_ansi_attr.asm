;
;       Sprinter C Library
;
; 	ANSI Video handling for Sprinter
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
;	$Id: f_ansi_attr.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_attr


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
	cp	5
	jr	nz,noblinkon
	ld	hl,text_attr
	set	7,(hl)
	inc	hl
	set	7,(hl)
	ret
.noblinkon
	cp	25
	jr	nz,noblinkoff
	ld	hl,text_attr
	res	7,(hl)
	inc	hl
	res	7,(hl)
	ret
.noblinkoff
	cp	7
	jr	z,switchreverse
	cp	27
	jr	nz,noreverse
.switchreverse
	ld	hl,text_attr
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	(hl),e
	dec	hl
	ld	(hl),d
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
	jr	calcinverse
.background
	cp	40
	ret	m
	cp	47+1
	ret	p
	sub	40
	ld	d,a
	rlca
	rlca
	rlca
	rlca
	and	@01110000
	ld	e,a
	ld	a,(text_attr)
	and	@10001111
	or	e
	ld	(text_attr),a
.calcinverse
	ld	e,a
	rlca
	rlca
	rlca
	rlca
	and	@01110000	;ink goes to paper
	ld	d,a
	ld	a,e
	rrca
	rrca
	rrca
	rrca
	and	@00000111
	or	d		
	ld	d,a		;d holds paper and ink
	ld	a,e
	and	@10001000
	or	d
	ld	(inverse_attr),a
	ret

	SECTION		code_crt_init

	ld	a,@00001111       ;bright white on black
	ld	(text_attr),a
	ld	a,@01111000       ;grey on white
	ld	(inverse_attr),a

	SECTION	bss_clib

	PUBLIC	text_attr
.text_attr	defb	0
.inverse_attr	defb	0
