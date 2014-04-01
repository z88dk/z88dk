
; void *zx_saddrpleft(void *saddr, uchar bitmask)

XDEF zx_saddrpleft

zx_saddrpleft:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrpleft.asm"
