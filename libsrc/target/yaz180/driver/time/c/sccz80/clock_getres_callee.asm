SECTION code_driver

PUBLIC clock_getres_callee

EXTERN asm_clock_getres

; get the the system time resolution

.clock_getres_callee
    pop af
    pop hl
    pop bc                          ; ignore the enum clock_id
    push af
    jp asm_clock_getres
