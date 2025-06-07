
    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_text_xypos


    EXTERN  MC6847_CONSOLE_COLUMNS
    EXTERN  MC6847_CONSOLE_ROWS

    EXTERN  __mc6847_mode
    EXTERN  __mc6847_MODE2_attr
    EXTERN  __pc6001_attr
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_flags
    EXTERN  mc6847_map_colour

    EXTERN  printc_MODE0
    EXTERN  printc_MODE1
    EXTERN  printc_MODE2

		; PC6001 - DISPLAY = $8200, COLOUR = $8000
		; PC6001mk2 - DISPLAY = $c200, COLOUR = $c000 (also unexpanded 6001)

    INCLUDE "video/mc6847/mc6847.inc"


generic_console_cls:
    GETSCREENADDRESS
    ld      a, (__mc6847_mode)
    and     a
    jr      z, cls_text
IF FORpc6001
    ;; PC6001 has an attribute map just below regular VRAM
    dec     h
    dec     h
    ld      l, 0
    ld      de,hl
    inc     de
	; NecTrek needs all characters setting
    ld      bc, 512
    ld      (hl), a                     ; TODO, Border colour is in here somewhere
    ldir
ELSE
    ld      d,h
    ld      e,1
ENDIF
IF FORmc1000
    ld      a,(__mc6847_mode)
    out     ($80), a
ENDIF

IF FORsv8000
    ld      hl, 3071                    ;sv8000 has lower res screen
ELSE
    ld      bc, 6143
ENDIF
    ld      (hl), 0
    ldir
IF FORmc1000
    set     0, a
    out     ($80), a
ENDIF
    ret
cls_text:
IF FORpc6001
    push    hl
    dec     h
    dec     h
    ld      d,h
    ld      e,1
    ld      bc, +(MC6847_CONSOLE_COLUMNS*MC6847_CONSOLE_ROWS)-1
    ld      a, (__pc6001_attr)
    ld      (hl), a
    ldir
    pop     hl
ENDIF

IF FORmc1000
    ld      a,(__mc6847_mode)
    out     ($80), a
ENDIF
    ld      d,h
    ld      e,1
    ld      bc, +(MC6847_CONSOLE_COLUMNS*MC6847_CONSOLE_ROWS)-1
    ld      (hl), 32
    ldir
IF FORmc1000
    set     0, a
    out     ($80), a
ENDIF
    ret




; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    ex      af, af
    ld      a, (__mc6847_mode)
    and     @11111101
    cp      MODE_1
    jp      z, printc_MODE1
    cp      MODE_2
    jp      z, printc_MODE2
IF !FORspec1000
    and     a
    ret     nz
    ex      af,af
ENDIF
    jp      printc_MODE0



generic_console_text_xypos:
    push    af
    ld      l, b
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl      ;*32
    IF FORpc6001
        ld      a,(SYSVAR_screen-1)
        inc     a
        inc     a
    ELSE
        ld      a,+(DISPLAY / 256)
    ENDIF
    ld      b, a
    add     hl, bc
    pop     af
    ret


generic_console_scrollup:
    push    de
    push    bc
    ld      a, (__mc6847_mode)
    and     @11111101
    jr      z, scrollup_text
    cp      MODE_1
    jr      z, scrollup_hires
    cp      MODE_2
    jr      z, scrollup_hires           ;possibly wrong
    pop     bc
    pop     de
    ret


scrollup_text:
    GETSCREENADDRESS
IF FORmc1000
    ld      a,(__mc6847_mode)
    out     ($80),a
    ex      af,af
ENDIF
    ld      l, MC6847_CONSOLE_COLUMNS
    ld      d, h
    ld      e, 0
    push    hl                          ; Save start of screen
    ld      bc, +((MC6847_CONSOLE_COLUMNS)*(MC6847_CONSOLE_ROWS-1))
    ldir
    ex      de, hl
    ld      b, MC6847_CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl), 32
    inc     hl
    djnz    generic_console_scrollup_3
    pop     hl                          ;Get screen back

IF FORpc6001
    dec     h
    dec     h
    ld      d, h
    ld      e, 0
    ld      bc, +((MC6847_CONSOLE_COLUMNS)*(MC6847_CONSOLE_ROWS-1))
    ldir
    ex      de, hl
    ld      b, MC6847_CONSOLE_COLUMNS
    ld      a, (__pc6001_attr)
generic_console_scrollup_4:
    ld      (hl), a
    inc     hl
    djnz    generic_console_scrollup_4
ENDIF

IF FORmc1000
    ex      af,af
    set     0,a
    out     ($80),a
ENDIF
    pop     bc
    pop     de
    ret

scrollup_hires:
    GETSCREENADDRESS
IF FORmc1000
    ld      a,(__mc6847_mode)
    out     ($80),a
    ex      af,af
ENDIF
    ld      de,hl
    inc     h
IF FORsv8000
    ld      bc, 32*88
ELSE
    ld      bc, 32*184
ENDIF
    ldir
    ex      de, hl
    ld      b, 0
    xor     a
scrollup_hires_1:
    ld      (hl), a
    inc     hl
    djnz    scrollup_hires_1
IF FORmc1000
    ex      af,af
    set     0,a
    out     ($80),a
ENDIF
    pop     bc
    pop     de
    ret
