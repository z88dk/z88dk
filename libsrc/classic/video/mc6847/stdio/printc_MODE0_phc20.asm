IF FORphc20

    SECTION code_driver

    PUBLIC  printc_MODE0
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_vpeek

    EXTERN  mc6847_from_ascii
    EXTERN  mc6847_to_ascii
    EXTERN  generic_console_text_xypos
    EXTERN  generic_console_flags


generic_console_set_attribute:
generic_console_set_ink:
generic_console_set_paper:
    ; We have no colour
    ret



; c = x
; b = y
; a = d = character to print
; e = raw
printc_MODE0:
    ld      a,d
    call    generic_console_text_xypos
    rr      e
    call    nc, mc6847_from_ascii
    ld      c,a
    ld      a,(generic_console_flags)
    rrca
    and     64
    or      c
    ld      (hl),a
    ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    call    generic_console_text_xypos
    rr      e
    call    nc,mc6847_to_ascii
    and     a
    ret


ENDIF