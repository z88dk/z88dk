
; void *zx_saddrpright(void *saddr, uint bitmask)

XDEF zx_saddrpright

zx_saddrpright:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_zx_saddrpright.asm"
