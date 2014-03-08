
; void *zx_saddrpright(void *saddr, uint bitmask)

XDEF zx_saddrpright

zx_saddrpright:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_zx_saddrpright.asm"
