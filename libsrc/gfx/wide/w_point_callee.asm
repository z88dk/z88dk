;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Written around the Interlogic Standard Library
;
;      Stubs Written by D Morris - 30/9/98
;
;
;    $Id: w_point_callee.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  point(int x, int y)
;Result is true/false


    SECTION code_graphics

    PUBLIC    point_callee
    PUBLIC    _point_callee
    PUBLIC    ASMDISP_POINT_CALLEE

    EXTERN    swapgfxbk
    EXTERN    swapgfxbk1

    EXTERN    w_pointxy
    INCLUDE "graphics/grafix.inc"


.point_callee
._point_callee

    pop bc
    pop de    ; y
    pop hl    ; x
    push bc

.asmentry
IF !__CPU_INTEL__
    push    ix
ENDIF
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF             
    call    w_pointxy
IF NEED_swapgfxbk = 1
    push       af
    call    swapgfxbk1
    pop    af
ENDIF
IF !__CPU_INTEL__
    pop    ix
ENDIF
             ld     hl,1
             ret    nz      ;pixel set
             dec    hl
             ret

DEFC ASMDISP_POINT_CALLEE = asmentry - point_callee
