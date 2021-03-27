;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Written around the Interlogic Standard Library
;
;      Stubs Written by D Morris - 30/9/98
;
;      Wide resolution (int type parameters) version by Stefano Bodrato
;
;    $Id: w_drawto.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC drawto
PUBLIC _drawto
EXTERN drawto_callee
EXTERN ASMDISP_DRAWTO_CALLEE

.drawto
._drawto

    pop    af
    ;pop bc
    pop    de
    pop    hl
    push    hl
    push    de
    ;push    bc
    push    af


   jp drawto_callee + ASMDISP_DRAWTO_CALLEE
ENDIF
