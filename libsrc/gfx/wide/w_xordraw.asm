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
                pop de          ;y2
                pop     hl      ;x2
                exx                     ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
                pop de          ;y1
                pop hl          ;x1
                push hl
                push de
                exx
                push hl
                push de
                exx

                push af         ; ret addr
		
   jp xordraw_callee + ASMDISP_XORDRAW_CALLEE
 
ENDIF
