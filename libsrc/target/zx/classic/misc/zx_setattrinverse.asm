; Valid for +zx, +ts2068, +zxn
; 

   SECTION  code_driver
   PUBLIC   zx_setattrinverse
   PUBLIC   _zx_setattrinverse
   PUBLIC   zx_setattrinverse_fastcall
   PUBLIC   _zx_setattrinverse_fastcall
   EXTERN   generic_console_flags

zx_setattrinverse:
_zx_setattrinverse:
    ld     hl,2
    add    hl,sp
    ld     l,(hl)
zx_setattrinverse_fastcall:
_zx_setattrinverse_fastcall:
    ld      a,l
    ld      hl, generic_console_flags
    rl      (hl)  ; drop inverse bit
    rra      
    rr      (hl)  ; rotate new bit in
    ret
