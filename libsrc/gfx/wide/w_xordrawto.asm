;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Written around the Interlogic Standard Library
;
;      Stubs Written by D Morris - 30/9/98
;
;      Wide resolution (int type parameters) version by Stefano Bodrato
;
;    $Id: w_xordrawto.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC xordrawto
PUBLIC _xordrawto
EXTERN xordrawto_callee
EXTERN ASMDISP_XORDRAWTO_CALLEE

.xordrawto
._xordrawto

    pop    af
    pop    de
    pop    hl
    push    hl
    push    de
    push    af


   jp xordrawto_callee + ASMDISP_XORDRAWTO_CALLEE
ENDIF
