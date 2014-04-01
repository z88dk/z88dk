
; void *zx_aaddrcdown(void *attraddr)

XDEF zx_aaddrcdown

zx_aaddrcdown:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_aaddrcdown.asm"
