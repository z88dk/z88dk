


SECTION code_clib

PUBLIC  generic_console_vpeek

EXTERN  vpeek_TEXT
EXTERN  vpeek_BITMAP

EXTERN  __aquarius_mode

;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    ld      hl,__aquarius_mode
    bit     0,(hl)
    jp      nz,vpeek_TEXT
    bit     2,(hl)
    jp      nz,vpeek_BITMAP
    ret


