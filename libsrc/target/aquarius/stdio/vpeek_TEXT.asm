
SECTION code_clib

PUBLIC vpeek_TEXT

EXTERN xypos_TEXT



;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
vpeek_TEXT:
    call    xypos_TEXT
    ld      a,(hl)
    and     a
    ret
