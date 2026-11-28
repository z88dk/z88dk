
    MODULE  pc8001_getmaxx
    SECTION code_clib
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    EXTERN  __console_w
    EXTERN  __pc8001_gfxmode

; Semigraphics have two pixels per column: 160 wide in 80 column mode.
; The mkII hires modes are 640 and 320 wide.
getmaxx:
_getmaxx:
    ld      a, (__pc8001_gfxmode)
    ld      hl, 639
    dec     a
    ret     z
    ld      hl, 319
    dec     a
    ret     z
    ld      a, (__console_w)
    add     a
    dec     a
    ld      l, a
    ld      h, 0
    ret
