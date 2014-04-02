
; void *zx_saddrcup(void *saddr)

XDEF _zx_saddrcup

_zx_saddrcup:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrcup.asm"
