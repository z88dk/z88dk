

    SECTION code_clib

    PUBLIC  tank
    PUBLIC  _tank

    EXTERN  asm_fix16_tan


tank:
_tank:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_tan

