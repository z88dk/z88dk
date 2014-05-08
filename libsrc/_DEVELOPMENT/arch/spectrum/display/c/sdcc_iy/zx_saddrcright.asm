
; void *zx_saddrcright(void *saddr)

PUBLIC _zx_saddrcright

_zx_saddrcright:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrcright.asm"
