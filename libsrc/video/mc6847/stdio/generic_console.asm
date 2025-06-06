
    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_text_xypos
    PUBLIC  generic_console_plotc
    PUBLIC  generic_console_pointxy

    PUBLIC  __mc6847_attr

    EXTERN  MC6847_CONSOLE_COLUMNS
    EXTERN  MC6847_CONSOLE_ROWS

    EXTERN  __mc6847_mode
    EXTERN  __mc6847_MODE2_attr
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_flags
    EXTERN  mc6847_map_colour

    EXTERN  printc_MODE1
    EXTERN  printc_MODE2

		; PC6001 - DISPLAY = $8200, COLOUR = $8000
		; PC6001mk2 - DISPLAY = $c200, COLOUR = $c000 (also unexpanded 6001)

    INCLUDE "video/mc6847/mc6847.inc"

generic_console_set_attribute:
    ld      a, (hl)
    ld      c, 0
    rlca
    rl      c
    ld      a, (__mc6847_attr)
    and     254
    or      c
    ld      (__mc6847_attr), a
    ret

generic_console_set_ink:
    call    mc6847_map_colour
    ld      a, b
    and     7
    ld      (__ink_colour), a
    rrca
    rrca
    and     @11000000
    ld      (__mc6847_MODE2_attr), a
set_css:
    ld      a, b
    rlca
    rlca
    and     @00000010
    ld      c, a
    ld      a, (__mc6847_attr)
    and     @11111101
    or      c
    ld      (__mc6847_attr), a
    ret


generic_console_set_paper:
    call    mc6847_map_colour
    ld      a, b
    rrca
    rrca
    and     @11000000
    ld      (__mc6847_MODE2_attr+1), a
    jr      set_css

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
    ld      bc, 6143
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
    ld      a, (__mc6847_attr)
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


; Entry point for plotting text graphics
; c = x
; b = y
; a = graphic glyph to print
; e = 0, 2x2 mode, e = 1, 3x2 mode
generic_console_plotc:
    call    generic_console_text_xypos
    ld      c, a
IF FORmc1000
    ld      a,(__mc6847_mode)
    out     ($80), a
ENDIF
    ld      a, (__mc6847_MODE2_attr)           ;It's shifted for us
    and     @11000000
    or      c
    ld      (hl), a
IF FORpc6001
    dec     h
    dec     h
    ld      a, (__ink_colour)
    rrca
    and     2                           ;Set the CSS flag as appropriate
    or      @01111101                   ;3x2, CSS not set
    ld      (hl), a
ENDIF

IF FORmc1000
    ld      a,(__mc6847_mode)
    set     0,a
    out     ($80),a
ENDIF
    ret

; Entry point for pointing text graphics
; c = x
; b = y
; Exit: a = graphic glyph
;	nc = found
;        c = not found
generic_console_pointxy:
    call    generic_console_text_xypos
    ld      c, (hl)                     ;glyph
    dec     h
    dec     h
    ld      a, (hl)
    and     @01111101
    cp      @01111101
    ld      a, 0                        ;No graphics drawn
    ret     nz                          ;Not a graphics character
    ld      a, c
    and     @00111111
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
    and     a
    ret     nz

printc_text:
IF FORmc1000
    out     ($80),a
ENDIF
    ex      af, af
    call    generic_console_text_xypos
    ld      (hl), a
IF FORpc6001
    dec     h
    dec     h
    ld      a, (__mc6847_attr)
    ld      (hl), a
ENDIF
IF FORmc1000
    ex      af,af
    set     0,a
    out     ($80),a
ENDIF
    ret


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
    dec     h
    dec     h
    ld      d, h
    ld      e, 0
    ld      bc, +((MC6847_CONSOLE_COLUMNS)*(MC6847_CONSOLE_ROWS-1))
    ldir
    ex      de, hl
    ld      b, MC6847_CONSOLE_COLUMNS
    ld      a, (__mc6847_attr)
generic_console_scrollup_4:
    ld      (hl), a
    inc     hl
    djnz    generic_console_scrollup_4
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
    ld      bc, 32*184
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



    SECTION data_clib

__mc6847_attr:
    defb    32                          ;We use the external character generator
__ink_colour:
    defb    7
