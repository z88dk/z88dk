
    SECTION code_clib
    PUBLIC  saa_etracker_init
    PUBLIC  _saa_etracker_init
    EXTERN  asm_etracker_init


saa_etracker_init:
_saa_etracker_init:
    pop     bc
    pop     hl
    push    hl
    push    bc
    jp      asm_etracker_init
