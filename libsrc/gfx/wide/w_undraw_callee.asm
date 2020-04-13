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
                pop     de      ;y2
                pop     hl      ;x2
                exx                     ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
                pop de          ;y1
                pop hl          ;x1
                push af         ; ret addr
		
.asmentry

                push ix
                push hl         ;x1
                push de         ;y1
		
		call    swapgfxbk
		call	w_respixel

                exx
                ex      de,hl
                pop     bc      ;y1
                or      a
                sbc     hl,bc
                ex      de,hl

                pop     bc              ;x1
                or      a
                sbc     hl,bc

		ld      ix,w_respixel
		call    w_line_r
		jp      __graphics_end


DEFC ASMDISP_UNDRAW_CALLEE = asmentry - undraw_callee
ENDIF
