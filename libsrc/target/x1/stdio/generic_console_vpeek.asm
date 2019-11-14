
    SECTION code_clib
    PUBLIC  generic_console_vpeek

    EXTERN  generic_console_xypos


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    call    generic_console_xypos
    ld      c,l
    ld      b,h
    in      a,(c)
    and     a
    ret
