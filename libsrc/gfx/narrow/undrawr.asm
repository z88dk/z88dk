;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;     Stubs Written by D Morris - 30/9/98
;
;
;    $Id: undrawr.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  undrawr(int x2, int y2)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION   code_graphics
    
    PUBLIC    undrawr
    PUBLIC    _undrawr
    
    EXTERN undrawr_callee
    EXTERN ASMDISP_UNDRAWR_CALLEE


.undrawr
._undrawr
    pop    af    ; ret addr
    pop de    ; y
    pop hl    ; x
    push hl
    push de
    push    af    ; ret addr
    
   jp undrawr_callee + ASMDISP_UNDRAWR_CALLEE
ENDIF
