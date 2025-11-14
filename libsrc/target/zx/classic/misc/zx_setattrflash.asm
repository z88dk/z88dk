; Valid for +zx, +ts2068, +zxn
; 

   SECTION  code_driver
   PUBLIC   zx_setattrflash
   PUBLIC   _zx_setattrflash
   PUBLIC   zx_setattrflash_fastcall
   PUBLIC   _zx_setattrflash_fastcall
   EXTERN   __zx_console_attr

zx_setattrflash:
_zx_setattrflash:
    ld     hl,2
    add    hl,sp
    ld     l,(hl)
zx_setattrflash_fastcall:
_zx_setattrflash_fastcall:
    ld      a,l
    ld      hl, __zx_console_attr
    rl      (hl)	;drop flash bit
    rra      		;lsb of parameter into carry
    rr      (hl)	;and then carry into flash bit
    ret
