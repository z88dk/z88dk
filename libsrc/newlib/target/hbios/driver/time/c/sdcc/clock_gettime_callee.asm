SECTION code_driver

PUBLIC _clock_gettime_callee

EXTERN asm_clock_gettime

; get the the system time

_clock_gettime_callee:
    pop af
    inc sp                          ; ignore the enum clock_id
    pop hl
    push af
    jp asm_clock_gettime
