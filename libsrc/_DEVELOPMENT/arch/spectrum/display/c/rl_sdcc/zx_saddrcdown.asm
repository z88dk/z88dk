
; void *zx_saddrcdown(void *saddr)

XDEF zx_saddrcdown

zx_saddrcdown:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddrcdown.asm"
