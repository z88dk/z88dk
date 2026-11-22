SECTION code_driver

PUBLIC clock_gettime

EXTERN asm_clock_gettime

; get the the system time

.clock_gettime
    pop af
    pop hl
    push hl
    push af
    jp asm_clock_gettime
