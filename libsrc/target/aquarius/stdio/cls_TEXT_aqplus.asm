        #include    "target/aquarius/def/plus.inc"
        SECTION code_clib

        PUBLIC  cls_TEXT

        EXTERN  __aquarius_attr
	EXTERN	__aquarius_mode
        EXTERN  DISPLAY
        EXTERN  COLOUR_MAP

cls_TEXT:
        ld      hl, DISPLAY
        ld      de, DISPLAY+1
        ld      (hl), 32

        ld      a, (__aquarius_mode)
        bit     6, a
        jr      z, col40cls

col80cls:
        ; Fill entire text ram so we include the
        ; border character at offset 2047
        ld      bc, 2047
        ldir

        ld      hl, DISPLAY
        ld      de, DISPLAY+1
        ; Enable second text page which
        ; in 80 col mode is the color RAM
        ld      b, a
        or      VCTRL_TEXT_PAGE
        out     (IO_VCTRL), a
        ld      a, (__aquarius_attr)
        ld      (hl), a
        ld      a, b
        ; Fill entire color ram so we include the
        ; border color at offset 2047
        ld      bc, 2047
        ldir

        ; Restore the original value
        out     (IO_VCTRL), a
        ret

col40cls:
        ; Fill entire text ram so we include the
        ; border character at offset 1023
        ld      bc, 1023
        ldir

        ld      hl, COLOUR_MAP
        ld      de, COLOUR_MAP+1
        ; Fill entire color ram so we include the
        ; border color at offset 1023
        ld      bc, 1023
        ld      a, (__aquarius_attr)
        ld      (hl), a
        ldir
        ret

