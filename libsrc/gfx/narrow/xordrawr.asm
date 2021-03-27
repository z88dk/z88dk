;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;     Stubs Written by D Morris - 30/9/98
;
;
;    $Id: xordrawr.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xordrawr(int x2, int y2)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION   code_graphics
    
    PUBLIC    xordrawr
    PUBLIC    _xordrawr
    
    EXTERN xordrawr_callee
    EXTERN ASMDISP_XORDRAWR_CALLEE


.xordrawr
._xordrawr
    pop    af    ; ret addr
    pop de    ; y
    pop hl    ; x
    push hl
    push de
    push    af    ; ret addr
    
   jp xordrawr_callee + ASMDISP_XORDRAWR_CALLEE
ENDIF
