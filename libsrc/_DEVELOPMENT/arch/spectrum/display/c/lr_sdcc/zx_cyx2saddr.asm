
; void *zx_cyx2saddr(uchar row, uchar col)

XDEF zx_cyx2saddr

zx_cyx2saddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   
   INCLUDE "arch/spectrum/display/z80/asm_zx_cyx2saddr.asm"
