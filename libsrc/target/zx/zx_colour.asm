; 09.2009 stefano

; void zx_colour(uint colour)

    SECTION code_clib
    PUBLIC  zx_colour
    PUBLIC  _zx_colour
    PUBLIC  zx_colour_fastcall
    PUBLIC  _zx_colour_fastcall
    EXTERN  __zx_console_attr

zx_colour:
_zx_colour:
   ld      hl,2
   add     hl,sp
   ld      l,(hl)

zx_colour_fastcall:
_zx_colour_fastcall:
    ld      a, i
    push    af
    di

    ld      a, l
        ;ld  (23624),a
    ld      (__zx_console_attr), a

    ld      d, l
    ld      e, l
    ld      hl, 0
    ld      b, 48
    add     hl, sp
    ld      sp, 16384+6912
clrloop:
    push    de
    push    de
    push    de
    push    de

    push    de
    push    de
    push    de
    push    de
    djnz    clrloop

    ld      sp, hl
    pop     af
    ret     po
    ei
    ret
