SECTION code_driver

PUBLIC _clock_getres

EXTERN asm_clock_getres

; get the the system time resolution

_clock_getres:
    pop af
    inc sp                          ; ignore the enum clock_id
    pop hl
    push hl
    dec sp
    push af
    jp asm_clock_getres
