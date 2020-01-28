;
;       ZX81 pseudo graphics routines
;
;       cls ()  -- clear screen and init UDG
;
;       Stefano Bodrato - 2014
;
;
;       $Id: clg.asm,v 1.3 2016-06-27 20:26:33 dom Exp $
;

		        SECTION code_clib
			PUBLIC    clg
			PUBLIC    _clg
			EXTERN     loadudg6
			EXTERN     filltxt
			EXTERN	base_graphics

			INCLUDE	"graphics/grafix.inc"


.clg
._clg
	
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
