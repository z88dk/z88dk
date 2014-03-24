
; void *zx_saddrpup(void *saddr)

XDEF zx_saddrpup

zx_saddrpup:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrpup.asm"
