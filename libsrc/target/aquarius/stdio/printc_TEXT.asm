
SECTION code_clib

PUBLIC printc_TEXT

EXTERN xypos_TEXT
EXTERN __aquarius_attr


; c = x
; b = y
; a = d = character to print
; e = raw
printc_TEXT:
    call    xypos_TEXT
    ld      (hl),d
    inc     h
    inc     h
    inc     h
    inc     h
    ld      a,(__aquarius_attr)
    ld      (hl),a
    ret
