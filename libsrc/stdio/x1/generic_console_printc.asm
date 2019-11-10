        SECTION     code_clib

        PUBLIC      generic_console_printc

        EXTERN      generic_console_xypos
        EXTERN      __x1_attr


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    call    generic_console_xypos
    ld      c,l
    ld      b,h
    out     (c),a
    res     4,b
    ld      a,(__x1_attr)
    out     (c),a
    ret




