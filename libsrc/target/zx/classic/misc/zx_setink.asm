; Valid for +zx, +ts2068, +zxn
; 

   SECTION  code_driver
   PUBLIC   zx_setink
   PUBLIC   _zx_setink
   PUBLIC   zx_setink_fastcall
   PUBLIC   _zx_setink_fastcall
   EXTERN   __zx_console_attr
   EXTERN   __zx_ink_colour

zx_setink:
_zx_setink:
    ld     hl,2
    add    hl,sp
    ld     l,(hl)
zx_setink_fastcall:
_zx_setink_fastcall:
     ld    a,l
IF    FORzxn
    ld      (__zx_ink_colour), a
ENDIF
    and     7
    ld      c, a
    ld      hl, __zx_console_attr
    ld      a, (hl)
    and     @11111000
    or      c
    ld      (hl), a
    ret
