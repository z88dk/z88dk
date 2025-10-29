;
;       RC700 pseudo-graphics rountines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2025
;
;
;       $Id: clsgraph.asm $
;

    SECTION code_clib
    PUBLIC  cleargraphics
    PUBLIC  _cleargraphics
    EXTERN  generic_console_cls
    EXTERN  __bdos
    

    INCLUDE "classic/gfx/grafix.inc"

cleargraphics:
_cleargraphics:
    ld      e,12
    ld      c,2
    call    __bdos
    ld      e,148
    ld      c,2
    jp     __bdos




;--------------------------------------------------
    SECTION code_crt_init
    EXTERN  base_graphics
;    EXTERN  asm_set_cursor_state

    ld      hl, $f800
    ld      (base_graphics), hl

;    ld      l, 0x20                     ;disable cursor
;    call    asm_set_cursor_state
