;
; Drawbox
;
; Generic high resolution version
;
;
; $Id: w_drawb.asm,v 1.1 2016-10-17 15:07:05 stefano Exp $
;

	INCLUDE "graphics/grafix.inc"
 	SECTION code_clib
	PUBLIC	drawb
	PUBLIC	_drawb

	EXTERN	w_plotpixel
	EXTERN	w_line_r

	EXTERN	swapgfxbk
	EXTERN	swapgfxbk1

	
.drawb
._drawb
		call swapgfxbk

		ld ix,2
		add ix,sp
		
		ld l,(ix+6)
		ld h,(ix+7); x
		
		ld e,(ix+4)
		ld d,(ix+5); y
		
		push hl
		push de
		push ix
		call w_plotpixel	; top-left corner
		pop ix
		
		ld l,(ix+2) 
		ld h,(ix+3); width
		ld de,0
		
		push ix
		ld	ix,w_plotpixel
		call w_line_r
		pop ix
		
		ld hl,0
		ld e,(ix+0)
		ld d,(ix+1); height

		push ix
		ld	ix,w_plotpixel
		call w_line_r
		pop ix
		
		pop de
		pop hl
		push ix
		call w_plotpixel	; top-left corner
		pop ix
		call swapgfxbk1
		ret

		ld hl,0
		ld e,(ix+0)
		ld d,(ix+1); height

		push ix
		ld	ix,w_plotpixel
		call w_line_r
		pop ix
		
		ld l,(ix+2) 
		ld h,(ix+3); width
		ld de,0
		
		push ix
		ld	ix,w_plotpixel
		call w_line_r
		pop ix
		
		call swapgfxbk1
		ret
