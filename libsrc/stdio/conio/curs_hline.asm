; CALLER linkage for function pointers

    SECTION code_clib
    PUBLIC  curs_hline
    PUBLIC  _curs_hline
    PUBLIC  ___curs_hline
    EXTERN  asm_curs_hline

curs_hline:
_curs_hline:
___curs_hline:

    pop     hl
    pop     de
    pop     bc
    push    bc
    push    de
    push    hl

    jp      asm_curs_hline
