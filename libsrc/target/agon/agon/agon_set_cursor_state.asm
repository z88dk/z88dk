
SECTION code_clib

PUBLIC agon_set_cursor_state
PUBLIC _agon_set_cursor_state
PUBLIC ___agon_set_cursor_state
PUBLIC asm_agon_set_cursor_state

INCLUDE "target/agon/def/mos_api.inc"

defc _agon_set_cursor_state = agon_set_cursor_state
defc ___agon_set_cursor_state = agon_set_cursor_state

; void agon_set_cursor_state(int on)
agon_set_cursor_state:
    pop     bc
    pop     hl
    push    hl
    push    bc
    ld      a,l
asm_agon_set_cursor_state:
    ex      af,af
    ld      a,23
    AGONPUTC
    ld      a,1
    AGONPUTC
    ex      af,af
    AGONPUTC
    ret

