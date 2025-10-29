; CALLER linkage for function pointers

    SECTION code_clib
    PUBLIC  curs_vline
    PUBLIC  _curs_vline
    PUBLIC  ___curs_vline
    EXTERN  asm_curs_vline

curs_vline:
_curs_vline:
___curs_vline:

    pop     hl
    pop     de
    pop     bc
    push    bc
    push    de
    push    hl

    jp      asm_curs_vline
