
; void *zx_saddrpleft(void *saddr, uchar bitmask)

XDEF zx_saddrpleft

zx_saddrpleft:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_zx_saddrpleft.asm"
