
; void *zx_py2saddr(uchar y)

PUBLIC _zx_py2saddr

_zx_py2saddr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_py2saddr.asm"
