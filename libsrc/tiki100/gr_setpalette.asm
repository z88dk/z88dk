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

SECTION code_clib
PUBLIC gr_setpalette
PUBLIC _gr_setpalette

gr_setpalette:
_gr_setpalette:
	pop	bc
	pop	hl		; *palette
	pop	de		; len
	push	de
	push	hl
	push	bc

	ld	b,e
	ld	d,0
set_loop:
	ld	a,(hl)
	inc	hl
	push	bc
	push	de
	push	hl
	call	do_set
	pop	hl
	pop	de
	pop	bc
	inc	d
	djnz	set_loop

	ret
	

;
; Writes a single palette color from a palette of a given size,
; where the palette is looping through all 16 palette entries.
; Size 2, 4 and 16 makes sense, and no other values for size
; should be used.
;
;
; Input:
; 	A = Palette
; 	D = Position
; 	E = Size
;
.do_set
	ld	hl,($F04D)
	cpl				; complement color value
	ld	c,a
	di
	LD	A,(hl)			; Make sure it's not writing to palette when the palette is updated, just in case
	and	$7F
	OUT	($0C),A
	ld	b,$20			; Wait a bit
.wait_loop2
	djnz	wait_loop2
	ld	a,c			; Store palette to be written
	ld	(hl),a
	OUT	($14),A
	ei
.palette_loop
	DI
	LD	a,(hl)			; Prepare graphics port
	and	$30
	or	b			; palette position
	ld	c,a
	or	$80
	OUT	($0C),A			; Enable writing to palette at end of this scanline
	LD	b,$20			; wait for HBLANK to get the color copied in the requested palette position
.wait_loop
	djnz	wait_loop
	ld	a,c
	LD	(hl),a			; graphics port might have changed, so update corresponding data in RAM
	OUT	($0C),A			; disable writes to the palette
	EI
	ld	a,d			; move to next palette position for this color and palette size
	add	a,e
	ld	d,a
	CP	16
	JR	C,palette_loop
	RET
