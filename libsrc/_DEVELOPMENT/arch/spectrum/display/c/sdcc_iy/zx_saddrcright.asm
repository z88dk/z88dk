
; void *zx_saddrcright(void *saddr)

XDEF _zx_saddrcright

_zx_saddrcright:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrcright.asm"
