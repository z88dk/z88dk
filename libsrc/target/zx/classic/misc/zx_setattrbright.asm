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
    ld      hl,2
    add     hl,sp
    ld      l,(hl)
zx_setattrbright_fastcall:
_zx_setattrbright_fastcall:
    ld      c,l
    ld      hl, __zx_console_attr
    ld      a,(hl)
    rlca        ;bit 7 -> bit 0
    rla         ;dump out the bright bit
    rr      c
    rra
save:
    ld      (hl),a
    ret
