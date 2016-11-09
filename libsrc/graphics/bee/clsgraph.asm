;
;       MicroBEE pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2016
;
;
;       $Id: clsgraph.asm,v 1.2 2016-11-09 11:35:58 stefano Exp $
;

			SECTION   code_clib
			PUBLIC    cleargraphics
			EXTERN     loadudg6
			;EXTERN	base_graphics

			INCLUDE	"graphics/grafix.inc"


.cleargraphics

	di
;	ld a,128	; Enable Programmable Characters Graphics (exclude ROM font if any)
;	out ($1C),a

	ld   c,0	; first UDG chr$ to load
	ld	 b,64	; number of characters to load
	ld   hl,$F800	; UDG area (16 bytes per char)
	call loadudg6

	;ld	hl,(base_graphics)
;	ld	hl,$F000
;	ld	bc,80*25
;.clean
;	inc	hl
;	ld	(hl),' '
;	dec	bc
;	ld	a,b
;	or	c
;	jr	nz,clean

	ld	e,$1a	; text code for CLS (ADM 1-A terminal)
	ld	c,2		; caracter output
	jp	5		; BDOS

