SECTION code_driver

PUBLIC _clock_settime

EXTERN asm_clock_settime

; set the the system time

_clock_settime:
    pop af
    inc sp                          ; ignore the enum clock_id
    pop hl
    push hl
    dec sp
    push af
    jp asm_clock_settime
