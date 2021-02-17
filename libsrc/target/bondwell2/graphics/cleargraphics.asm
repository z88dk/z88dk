;
;       Bondwell 2 graphics routines
;
;       Stefano Bodrato 2021
;

	INCLUDE	"graphics/grafix.inc"

        SECTION   code_graphics
	
	PUBLIC	cleargraphics
	PUBLIC	_cleargraphics
	PUBLIC	clg
	PUBLIC	_clg

	EXTERN	base_graphics

	EXTERN    swapgfxbk
	EXTERN    swapgfxbk1

;
;	$Id: clsgraph.asm $
;

; ******************************************************************
;
;	Clear graphics	area, i.e. reset all bits in graphics
;
;
.clg
._clg
.cleargraphics
._cleargraphics

	ld	e,$1a			; USE BDOS to home the CP/M cursor
	ld	c,2
	push ix
	call 5
	pop  ix
	
	ld		bc,$21
	ld		a,5         ; VRAM start addr. low
	out		(c),a
	xor		a           ; set to 0
	dec		c
	out		(c),a
	
	inc		c
	ld		a,6         ; VRAM start addr. high
	out		(c),a
	xor		a           ; set to 0
	dec		c
	out		(c),a
	
	; clean first text row to hide the cursor
	ld		h,a
	ld		l,a
	ld		d,a
	ld		e,1	
	ld		bc,80*8
	
	call	swapgfxbk
	ld		(hl),0
	ldir
	jp		swapgfxbk1
