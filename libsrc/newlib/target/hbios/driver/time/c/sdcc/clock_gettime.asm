SECTION code_driver

PUBLIC _clock_gettime

EXTERN asm_clock_gettime

; get the the system time

_clock_gettime:
    pop af
    inc sp                          ; ignore the enum clock_id
    pop hl
    push hl
    dec sp
    push af
    jp asm_clock_gettime
