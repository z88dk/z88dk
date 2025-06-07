
    SECTION code_driver

    PUBLIC  generic_console_vpeek

    EXTERN  __mc6847_mode
    EXTERN  generic_console_text_xypos
    EXTERN  vpeek_MODE1
    EXTERN  vpeek_MODE2

    INCLUDE "video/mc6847/mc6847.inc"

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    ld      a, (__mc6847_mode)
IF MC6847_HAS_HIRES
    cp      MODE_HIRES
    jp      z, vpeek_MODE1
ENDIF
    cp      MODE_MULTICOLOUR
    jp      z, vpeek_MODE2

    and     a
    ccf
    ret     nz
    call    generic_console_text_xypos
IF FORmc1000
    ld      a, (__mc6847_mode)
    out     ($80), a
    ld      b, (hl)
    set     0, a
    out     ($80), a
    ld      a, b
ELSE
    ld      a, (hl)
ENDIF
    and     a
    ret
