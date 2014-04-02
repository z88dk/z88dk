
; void *zx_saddrpdown(void *saddr)

XDEF _zx_saddrpdown

_zx_saddrpdown:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrpdown.asm"
