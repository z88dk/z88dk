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
;	$Id: w_xordraw.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xordraw(int x, int y, int x2, int y2)

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC xordraw
PUBLIC _xordraw
EXTERN xordraw_callee
EXTERN ASMDISP_XORDRAW_CALLEE


.xordraw
._xordraw
		pop af
		
		pop de
		pop	hl
		exx			; w_xorpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop hl
		pop de
		
		push de
		push hl
		exx
		push hl
		push de
		;exx
		
		push af		; ret addr
		
   jp xordraw_callee + ASMDISP_XORDRAW_CALLEE
 
ENDIF
