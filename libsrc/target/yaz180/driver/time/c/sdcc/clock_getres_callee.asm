SECTION code_driver

PUBLIC _clock_getres_callee

EXTERN asm_clock_getres

; get the the system time resolution

_clock_getres_callee:
    pop af
    inc sp                          ; ignore the enum clock_id
    pop hl
    push af
    jp asm_clock_getres
