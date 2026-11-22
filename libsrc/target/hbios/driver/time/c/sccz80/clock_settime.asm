SECTION code_driver

PUBLIC clock_settime

EXTERN asm_clock_settime

; get the the system time

.clock_settime
    pop af
    pop hl
    push hl
    push af
    jp asm_clock_settime
