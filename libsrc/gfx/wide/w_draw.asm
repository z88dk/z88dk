;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Written around the Interlogic Standard Library
;
;      Stubs Written by D Morris - 30/9/98
;
;      Wide resolution (int type parameters) version by Stefano Bodrato
;

;
;    $Id: w_draw.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  draw(int x, int y, int x2, int y2)

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC draw
PUBLIC _draw
EXTERN draw_callee
EXTERN ASMDISP_DRAW_CALLEE

;EXTERN    __gfx_color

.draw
._draw
    pop af
    pop de    ;y2
    pop    hl    ;x2
    exx        ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop de    ;y1
    pop hl    ;x1
    push hl
    push de
    exx
    push hl
    push de
    exx
    
    push af    ; ret addr
    
; de = x1, hl = y1, hl'=x2, de'=y2
   jp draw_callee + ASMDISP_DRAW_CALLEE
 
ENDIF
