SECTION code_driver

PUBLIC clock_settime_callee

EXTERN asm_clock_settime

; get the the system time

.clock_settime_callee
    pop af
    pop hl
    pop bc                          ; ignore the enum clock_id
    push af
    jp asm_clock_settime
