;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (int type parameters) version by Stefano Bodrato
;

;
;	$Id: w_draw.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  draw(int x, int y, int x2, int y2)

SECTION code_graphics
PUBLIC draw
PUBLIC _draw
EXTERN draw_callee
EXTERN ASMDISP_DRAW_CALLEE

;EXTERN    __gfx_color

.draw
._draw
		pop af
		;pop bc	; color
		
		pop de
		pop	hl
		exx			; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop hl
		pop de
		exx		
		push de
		push hl
		exx
		push hl
		push de
		
		;push bc		
		push af		; ret addr
		
   jp draw_callee + ASMDISP_DRAW_CALLEE
 
