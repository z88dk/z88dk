    INCLUDE "classic/video/mc6847/mc6847.inc"

IFNDEF MC6847_IOSPACE

    SECTION code_driver

    PUBLIC  generic_console_cls

    EXTERN  __mc6847_mode
    EXTERN  __mc6847_modeval
    EXTERN  __mc6847_mode
    EXTERN  __mc6847_modeval
    EXTERN  __pc6001_attr
    EXTERN  __phc25_attr



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
    ld      d,h
    ld      e,1
	; NecTrek needs all characters setting
    ld      bc, 512
    ld      a,(__mc6847_modeval)
    ld      (hl), a                     ; TODO, Border colour is in here somewhere
    ldir
ELSE
    ld      d,h
    ld      e,1
ENDIF
IF FORmc1000
    ld      a,(__mc6847_modeval)
    out     ($80), a
ENDIF
IF FORsv8000
    ld      bc, 3071                    ;sv8000 has lower res screen
ELIF FORvz
    ld      bc, +(64 * 32)  - 1
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
ELIF FORphc25
    push    hl
    set     3,h
    ld      d,h
    ld      e,1
    ld      bc, +(MC6847_CONSOLE_COLUMNS*MC6847_CONSOLE_ROWS)-1
    ld      a, (__phc25_attr)
    ld      (hl), a
    ldir
    pop     hl
ENDIF

IF FORmc1000
    ld      a,(__mc6847_modeval)
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

ENDIF
