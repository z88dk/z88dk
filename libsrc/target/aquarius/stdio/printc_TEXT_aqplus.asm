        #include    "target/aquarius/def/plus.inc"
        SECTION code_clib

        PUBLIC  printc_TEXT

        EXTERN  xypos_TEXT
        EXTERN  __aquarius_attr


; c = x
; b = y
; a = d = character to print
; e = raw
printc_TEXT:
        call    xypos_TEXT
        ld      (hl), d

        in      a, (IO_VCTRL)
        bit     6, a
        jr      nz, col80

        inc     h
        inc     h
        inc     h
        inc     h
        ld      a, (__aquarius_attr)
        ld      (hl), a
        ret
col80:
        ; Enable second text page which
        ; in 80 col mode is the color RAM
        ld      b, a
        or      VCTRL_TEXT_PAGE
        out     (IO_VCTRL), a

        ld      a, (__aquarius_attr)
        ld      (hl), a

        ld      a, b
        out     (IO_VCTRL), a
        ret

