
; void *zx_py2saddr(uchar y)

XDEF zx_py2saddr

zx_py2saddr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_py2saddr.asm"
