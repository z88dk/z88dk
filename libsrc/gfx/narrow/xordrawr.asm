;
;     Z88 Graphics Functions - Small C+ stubs
; ----- void  xordrawr(int x2, int y2)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  xordrawr
    PUBLIC  _xordrawr
    
    EXTERN  asm_xordrawr

.xordrawr
._xordrawr
    pop     af    ; ret addr
    pop     de    ; y
    pop     hl    ; x
    push    hl
    push    de
    push    af    ; ret addr
    jp      asm_xordrawr
ENDIF
