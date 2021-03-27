;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;     Stubs Written by D Morris - 30/9/98
;
;
;    $Id: point.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  point(int x, int y)
;Result is true/false


    SECTION   code_graphics
    
    PUBLIC    point
    PUBLIC    _point
    
    EXTERN point_callee
    EXTERN ASMDISP_POINT_CALLEE

.point
._point

    pop    bc    ; ret addr
    pop hl    ; y
    pop de
    push de
    push hl
    ld    h,e    ; x
    push    bc    ; ret addr

   jp point_callee + ASMDISP_POINT_CALLEE
   

