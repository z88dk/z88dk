; Valid for +zx, +ts2068, +zxn

   SECTION  code_driver
   PUBLIC   zx_setpaper
   PUBLIC   _zx_setpaper
   PUBLIC   zx_setpaper_fastcall
   PUBLIC   _zx_setpaper_fastcall
   EXTERN   __zx_console_attr

zx_setpaper:
_zx_setpaper:
    ld     hl,2
    add    hl,sp
    ld     l,(hl)
zx_setpaper_fastcall:
_zx_setpaper_fastcall:
    ld      a,l
    and     @00111000
    jr      nz,set_paper
    ld      a,l
    rlca
    rlca
    rlca
set_paper:
    and     @00111000
    ld      c, a
    ld      hl, __zx_console_attr
    ld      a, (hl)
    and     @11000111
    or      c
    ld      (hl), a
    ret
