
; void *zx_saddrpdown(void *saddr)

XDEF zx_saddrpdown

zx_saddrpdown:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrpdown.asm"
