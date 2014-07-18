;
;       ZX81 pseudo graphics routines
;
;       cls ()  -- clear screen and init UDG
;
;       Stefano Bodrato - 2014
;
;
;       $Id: clg.asm,v 1.1 2014-07-18 06:18:08 stefano Exp $
;


			XLIB    clg
			LIB     loadudg6
			LIB     filltxt
			XREF	base_graphics

			INCLUDE	"graphics/grafix.inc"


.clg
	
	ld   c,0	; first UDG chr$ to load
	ld	 b,64	; number of characters to load

	ld   a,(base_graphics)
	and  a
	jr   nz,havebase
	add  $30
.havebase
	ld   i,a  ; Interrupt vector now points to the new font
	ld   h,a  ; UDG area
	ld   l,0

	call loadudg6
	
	ld   l,0
	jp  filltxt
