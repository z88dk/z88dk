
; void *zx_cyx2saddr(uchar row, uchar col)

XDEF zx_cyx2saddr

zx_cyx2saddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   
   INCLUDE "arch/spectrum/display/z80/asm_zx_cyx2saddr.asm"
