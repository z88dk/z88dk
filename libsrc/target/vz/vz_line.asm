; CALLER LINKAGE FOR FUNCTION POINTERS

    SECTION code_clib
    PUBLIC  vz_line
    PUBLIC  _vz_line
    EXTERN  vz_line_callee
    EXTERN  asm_vz_line

vz_line:
_vz_line:

    pop     af
    pop     bc
    pop     de
    pop     hl
    ld      d, e
    ld      e, l
    pop     hl
    ex      af, af
    ld      a, l
    pop     hl
    ld      h, a
    push    hl
    push    hl
    push    hl
    push    de
    push    bc
    ex      af, af
    push    af

    jp      asm_vz_line
