; Valid for +zx, +ts2068, +zxn
; 

   SECTION  code_driver
   PUBLIC   zx_setattrbright
   PUBLIC   _zx_setattrbright
   PUBLIC   zx_setattrbright_fastcall
   PUBLIC   _zx_setattrbright_fastcall
   EXTERN   __zx_console_attr

zx_setattrbright:
_zx_setattrbright:
    ld     hl,2
    add    hl,sp
    ld     c,(hl)
zx_setattrbright_fastcall:
_zx_setattrbright_fastcall:
    ld      hl, __zx_console_attr
    ld      a,(hl)
    and     @10111111
    rl      c
    jr      nc,save
    or      @01000000
save:
    ld      (hl),a
    ret
