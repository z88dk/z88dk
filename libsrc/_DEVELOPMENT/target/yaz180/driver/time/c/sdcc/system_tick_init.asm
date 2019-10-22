SECTION code_driver

PUBLIC _system_tick_init

EXTERN asm_system_tick_init

; initialize the system tick

_system_tick_init:
    pop af
    pop hl
    push hl
    push af
    jp asm_system_tick_init
