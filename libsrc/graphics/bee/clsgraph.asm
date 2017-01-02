;
;       MicroBEE pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2016
;
;
;       $Id: clsgraph.asm,v 1.5 2017-01-02 21:51:24 aralbrec Exp $
;

			SECTION   code_clib
			PUBLIC    cleargraphics
         PUBLIC    _cleargraphics
			EXTERN     loadudg6
			EXTERN     swapgfxbk
			;EXTERN	base_graphics

			INCLUDE	"graphics/grafix.inc"


.cleargraphics
._cleargraphics

	call	swapgfxbk

	ld   c,0	; first UDG chr$ to load
	ld	 b,64	; number of characters to load
	ld   hl,$F800	; UDG area (16 bytes per char)
	call loadudg6
	
	ld	a,64
	out (8),a
	ld	hl,$F800
	;ld  d,7*16
	ld  d,15
	call setattr
	xor a
	out (8),a

	ld  d,' '
	ld	hl,$F000
.setattr
	ld	bc,80*25
.clean
	inc	hl
	ld	a,d
	ld	(hl),a
	dec	bc
	ld	a,b
	or	c
	jr	nz,clean
	
	ld a,(5)
	cp 195
	ret nz

	ld	e,$1a	; text code for CLS (ADM 1-A terminal)
	ld	c,2		; character output
	jp	5		; BDOS

