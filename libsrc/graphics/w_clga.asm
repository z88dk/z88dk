
;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_clga.asm,v 1.1 2016-10-18 06:52:34 stefano Exp $
;


;Usage: clga(struct *pixels)

	INCLUDE "graphics/grafix.inc"
 	SECTION code_clib
	PUBLIC    clga
	PUBLIC    _clga

	EXTERN	w_respixel
	EXTERN	w_line_r

	EXTERN	swapgfxbk
	EXTERN	swapgfxbk1
	EXTERN	__graphics_end

	
.clga
._clga
		push	ix
		ld	ix,4
		add	ix,sp
		ld	l,(ix+6)
		ld	h,(ix+7)
		ld	e,(ix+4)
		ld	d,(ix+5)
		
		ld	c,(ix+0)
		ld	b,(ix+1)
		inc bc
		
		ex (sp),hl
		ld	l,(ix+2)
		ld	h,(ix+3)
		ex (sp),hl
		
.loop
		push hl
		push de
		push bc
		call    swapgfxbk
		call	w_respixel
		call    swapgfxbk1
		pop bc
		pop de
		pop hl
		ex (sp),hl
		
		push hl
		push de
		push bc
		ld de,0
		call    swapgfxbk
		ld      ix,w_respixel
		call    w_line_r
		call    swapgfxbk1
		pop bc
		pop de
		pop hl
		ex (sp),hl
		inc de
		dec bc
		ld a,b
		or c
		jr nz,loop

		pop ix
		ret

