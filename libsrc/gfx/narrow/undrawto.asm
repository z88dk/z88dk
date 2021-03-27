;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;     Stubs Written by D Morris - 30/9/98
;
;
;    $Id: undrawto.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  undrawto(int x2, int y2)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION   code_graphics
    
    PUBLIC    undrawto
    PUBLIC    _undrawto
    
    EXTERN undrawto_callee
    EXTERN ASMDISP_UNDRAWTO_CALLEE


.undrawto
._undrawto
    pop    af    ; ret addr
    pop de    ; y2
    pop hl
    push hl
    push de
    ld    d,l    ; x2
    push    af    ; ret addr
    
   jp undrawto_callee + ASMDISP_UNDRAWTO_CALLEE
ENDIF
