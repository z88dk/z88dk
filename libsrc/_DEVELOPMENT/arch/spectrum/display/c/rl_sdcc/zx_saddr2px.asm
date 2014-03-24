
; uint zx_saddr2px(void *saddr)

XDEF zx_saddr2px

zx_saddr2px:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddr2px.asm"
