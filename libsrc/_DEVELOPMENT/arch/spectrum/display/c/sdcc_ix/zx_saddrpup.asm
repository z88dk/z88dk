
; void *zx_saddrpup(void *saddr)

XDEF _zx_saddrpup

_zx_saddrpup:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrpup.asm"
