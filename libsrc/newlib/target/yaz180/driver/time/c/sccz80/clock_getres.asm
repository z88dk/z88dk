SECTION code_driver

PUBLIC clock_getres

EXTERN asm_clock_getres

; get the the system time resolution

.clock_getres
    pop af
    pop hl
    push hl
    push af
    jp asm_clock_getres
