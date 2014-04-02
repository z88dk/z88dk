
; void *zx_aaddrcright(void *attraddr)

XDEF _zx_aaddrcright

_zx_aaddrcright:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_aaddrcright.asm"
