SECTION code_driver

PUBLIC _clock_settime_callee

EXTERN asm_clock_settime

; set the the system time

_clock_settime_callee:
    pop af
    inc sp                          ; ignore the enum clock_id
    pop hl
    push af
    jp asm_clock_settime
