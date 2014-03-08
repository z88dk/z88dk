
; uint zx_aaddr2px(void *attraddr)

XDEF zx_aaddr2px

zx_aaddr2px:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_aaddr2px.asm"
