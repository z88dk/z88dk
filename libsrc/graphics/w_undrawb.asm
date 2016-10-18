;
; Undrawbox
;
; Generic high resolution version
;
;
; $Id: w_undrawb.asm,v 1.1 2016-10-18 06:52:34 stefano Exp $
;

	INCLUDE "graphics/grafix.inc"
 	SECTION code_clib
	PUBLIC	undrawb
	PUBLIC	_undrawb

	EXTERN	w_respixel
	EXTERN	w_line_r

	EXTERN	swapgfxbk
	EXTERN	swapgfxbk1
	EXTERN	__graphics_end

	
.undrawb
._undrawb
		push	ix
		ld	ix,4
		add	ix,sp
		ld	l,(ix+6)
		ld	h,(ix+7)
		ld	e,(ix+4)
		ld	d,(ix+5)
		
		push hl
		push de
		push ix

		call    swapgfxbk
		call	w_respixel
		call    swapgfxbk1

		pop ix
		ld	e,(ix+0)
		ld	d,(ix+1)
		ld  hl,0
		push ix
		
		call    swapgfxbk
		ld      ix,w_respixel
		call    w_line_r
		call    swapgfxbk1
		
		pop ix
		ld	l,(ix+2)
		ld	h,(ix+3)
		ld  de,0
		push ix
		
		call    swapgfxbk
		ld      ix,w_respixel
		call    w_line_r
		call    swapgfxbk1
		
		pop ix
		pop de
		pop hl
		push ix
		
		call    swapgfxbk
		call	w_respixel
		call    swapgfxbk1
		
		pop ix
		ld	l,(ix+2)
		ld	h,(ix+3)
		ld  de,0
		push ix
		
		call    swapgfxbk
		ld      ix,w_respixel
		call    w_line_r
		call    swapgfxbk1

		pop ix
		ld	e,(ix+0)
		ld	d,(ix+1)
		ld  hl,0
		push ix
		
		call    swapgfxbk
		ld      ix,w_respixel
		call    w_line_r

		jp      __graphics_end

