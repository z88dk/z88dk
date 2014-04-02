
; uint zx_aaddr2px(void *attraddr)

XDEF _zx_aaddr2px

_zx_aaddr2px:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_aaddr2px.asm"
