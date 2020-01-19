;
;       Z88 Graphics Functions
;       Written around the Interlogic Standard Library
;
;       Wide resolution (int type parameters) and CALLEE conversion by Stefano Bodrato, 2018
;
; ----- void __CALLEE__ undraw(int x, int y, int x2, int y2)
;
;
;	$Id: w_undraw_callee.asm $
;

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC undraw_callee
PUBLIC _undraw_callee
PUBLIC ASMDISP_UNDRAW_CALLEE

	EXTERN     swapgfxbk
	EXTERN    swapgfxbk1

	EXTERN     w_line_r
	EXTERN     w_respixel
	EXTERN     __graphics_end



.undraw_callee
._undraw_callee
		pop af
		
		pop de
		pop	hl
		exx			; w_respixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop hl
		pop de
		
		push af		; ret addr
		
		exx
		
.asmentry
		
;		ld	l,(ix+6)
;		ld	h,(ix+7)
;		ld	e,(ix+4)
;		ld	d,(ix+5)
;		ld	c,(ix+8)
		
		push ix
		
		push hl
		push de

		call    swapgfxbk
		call	w_respixel
		;call    swapgfxbk1
		;pop ix

		exx
		;ld	l,(ix+0)
		;ld	h,(ix+1)
		pop bc
		or a
		sbc hl,bc
		ex de,hl
		
		;ld	l,(ix+2)
		;ld	h,(ix+3)
		pop bc
		or a
		sbc hl,bc

		;call    swapgfxbk
		;push	ix
		ld      ix,w_respixel
		call    w_line_r
		jp      __graphics_end


DEFC ASMDISP_UNDRAW_CALLEE = asmentry - undraw_callee
ENDIF
