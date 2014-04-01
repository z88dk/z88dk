
; void *zx_saddrcright(void *saddr)

XDEF zx_saddrcright

zx_saddrcright:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrcright.asm"
