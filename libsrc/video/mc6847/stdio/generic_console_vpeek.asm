
    SECTION code_driver

    PUBLIC  generic_console_vpeek

    EXTERN  __mc6847_mode
    EXTERN  __mc1000_modeval
    EXTERN  generic_console_text_xypos
    EXTERN  vpeek_MODE1
    EXTERN  vpeek_MODE2
    EXTERN  __tms9918_console_vpeek

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
    cp      1
    jp      z, vpeek_MODE1
ENDIF
    cp      2
    jp      z, vpeek_MODE2
IF FORspc1000
    cp      10
    jp      nz,__tms9918_console_vpeek
ENDIF
    and     a
    ccf
    ret     nz
    call    generic_console_text_xypos
IF FORmc1000
    ld      a, (__mc1000_modeval)
    out     ($80), a
    ld      b, (hl)
    set     0, a
    out     ($80), a
    ld      a, b
ELIF FORspc1000
    ld      bc,hl
    in      a,(c)
ELSE
    ld      a, (hl)
ENDIF
    and     a
    ret
