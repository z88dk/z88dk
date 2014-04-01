
; void *zx_cyx2aaddr(uchar row, uchar col)

XDEF zx_cyx2aaddr

zx_cyx2aaddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   
   INCLUDE "arch/spectrum/display/z80/asm_zx_cyx2aaddr.asm"
