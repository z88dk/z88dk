
; void *zx_py2aaddr(uchar y)

XDEF zx_py2aaddr

zx_py2aaddr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_py2aaddr.asm"
