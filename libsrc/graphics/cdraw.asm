; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void __CALLEE__ cdraw_callee(int x, int y, int x2, int y2, int c)

SECTION code_clib
PUBLIC cdraw
PUBLIC _cdraw
EXTERN cdraw_callee
EXTERN ASMDISP_CDRAW_CALLEE

EXTERN    __gfx_color

.cdraw
._cdraw
		pop af
		pop bc	; color
		pop de
		pop	hl
		exx			; w_cplotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop hl
		pop de
		
		push de
		push hl
		exx
		push hl
		push de
		push bc
		
		push af		; ret addr
		
   jp cdraw_callee + ASMDISP_CDRAW_CALLEE
 
