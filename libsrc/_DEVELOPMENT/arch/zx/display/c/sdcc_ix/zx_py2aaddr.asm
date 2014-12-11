
; void *zx_py2aaddr(uchar y)

SECTION code_arch

PUBLIC _zx_py2aaddr

_zx_py2aaddr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_py2aaddr.asm"
