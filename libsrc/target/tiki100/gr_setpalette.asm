;
;	TIKI-100 graphics routines
;	by Stefano Bodrato, Fall 2015
;
;	Edited by Frode van der Meeren
;
;   Palette is always 16 colors long, 'len' is the number
;   of colors being passed, which will be copied many times
;
; void __FASTCALL__ gr_setpalette(int len, char *palette)
;
;	Changelog:
;
;	v1.2 - FrodeM
;	   * Made sure no palette writes take place when palette register is updated
;	   * Palette register is only written to once per entry in char palette
;	   * Use address $F04D to store graphics mode instead of dedicated byte
;
;	$Id: gr_setpalette.asm,v 1.3 2016-06-10 23:01:47 dom Exp $
;

	SECTION		code_clib
	PUBLIC		gr_setpalette
	PUBLIC		_gr_setpalette

	INCLUDE		"target/cpm/def/tiki100.def"

gr_setpalette:
_gr_setpalette:
	pop	bc
	pop	hl		; *palette
	pop	de		; len
	push	de
	push	hl
	push	bc

	ld	d,e		; Number of colours in selected mode
	ld	b,0		; Palette index

	ld	a,e
set_loop:
	push	af
	ld	a,(hl)
	inc	hl
	push	bc
	push	de
	push	hl
	call	do_set
	pop	hl
	pop	de
	pop	bc
	inc	b
	pop	af
	dec	a
	jr	nz,set_loop

	ret
	

;
; Writes a single palette color from a palette of a given size,
; where the palette is looping through all 16 palette entries.
; Size 2, 4 and 16 makes sense, and no other values for size
; should be used.
;
;
; Input:
; 	A = Palette color
; 	B = Palette index
;	D = number of colours in selected mode
;
.do_set
	cpl
	ld	e,a
	ld	hl,PORT_0C_COPY
.palette_loop
	push	de
	di
	ld	a,(hl)
	and	$7F
	out	($0C),a		; Make sure write-flag is clear in advance to avoid hardware race-conditions
	ld	a,e
	out	($14),a		; Set palette register (prepare the color to be loaded)
	ld	a,(hl)
	and	$70
	or	b
	out	($0C),a		; Set index
	or	$80
	out	($0C),a		; Initiate write
	ld	c,18
.wait_loop
	dec	c
	jp	nz,wait_loop	; wait 288 clocks, 72usec for HBLANK to trigger (64usec period + 8usec margin)
	and	$7F
	out	($0C),a		; End write
	ld	(hl),a
	ei
	pop	de

	ld	a,b
	add	d		; Set all palettes which corresponds to the given color in the given mode
	ld	b,a
	cp	16
	jr	c,palette_loop
	ret
