;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;     Stubs Written by D Morris - 30/9/98
;
;
;    $Id: xordrawto.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xordrawto(int x2, int y2)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION   code_graphics
    
    PUBLIC    xordrawto
    PUBLIC    _xordrawto
    
    EXTERN xordrawto_callee
    EXTERN ASMDISP_XORDRAWTO_CALLEE


.xordrawto
._xordrawto
    pop    af    ; ret addr
    pop de    ; y2
    pop hl
    push hl
    push de
    ld    d,l    ; x2
    push    af    ; ret addr
    
   jp xordrawto_callee + ASMDISP_XORDRAWTO_CALLEE
ENDIF
