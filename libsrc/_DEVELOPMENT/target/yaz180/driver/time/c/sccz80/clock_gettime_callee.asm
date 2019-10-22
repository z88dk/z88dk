SECTION code_driver

PUBLIC clock_gettime_callee

EXTERN asm_clock_gettime

; get the the system time

.clock_gettime_callee
    pop af
    pop hl
    push af
    jp asm_clock_gettime
