
    MODULE  pc8001_getmaxy
    SECTION code_clib
    PUBLIC  getmaxy
    PUBLIC  _getmaxy
    EXTERN  __console_h
    EXTERN  __pc8001_gfxmode

; Semigraphics have four pixels per row: 100 high. The mkII hires modes
; are 200 high.
getmaxy:
_getmaxy:
    ld      a, (__pc8001_gfxmode)
    and     a
    ld      hl, 199
    ret     nz
    ld      a, (__console_h)
    add     a
    add     a
    dec     a
    ld      l, a
    ld      h, 0
    ret
