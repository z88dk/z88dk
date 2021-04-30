; void xordrawr(int px, int py)
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  xordrawr
    PUBLIC  _xordrawr
    EXTERN  asm_xordrawr

.xordrawr
._xordrawr
    pop     af
    pop     de
    pop     hl
    push    hl
    push    de
    push    af
    jp      asm_xordrawr
ENDIF
