
; void *zx_saddrpdown(void *saddr)

XDEF zx_saddrpdown

zx_saddrpdown:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_saddrpdown.asm"
