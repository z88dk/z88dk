
; uint zx_saddr2cy(void *saddr)

XDEF _zx_saddr2cy

_zx_saddr2cy:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_saddr2cy.asm"
