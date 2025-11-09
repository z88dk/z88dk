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
    ld      a, l
    ld      (__zx_console_attr), a
    
    ld      hl,$5800
    ld      de,$5801
    ld      (hl),a
    ld      bc,767
    ldir
    ret