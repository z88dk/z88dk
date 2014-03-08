
; void *zx_cyx2aaddr(uchar row, uchar col)

XDEF zx_cyx2aaddr

zx_cyx2aaddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   
   INCLUDE "../../z80/asm_zx_cyx2aaddr.asm"
