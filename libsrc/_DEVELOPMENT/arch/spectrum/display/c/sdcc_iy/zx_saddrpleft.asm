
; void *zx_saddrpleft(void *saddr, uchar bitmask)

XDEF _zx_saddrpleft

_zx_saddrpleft:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrpleft.asm"
