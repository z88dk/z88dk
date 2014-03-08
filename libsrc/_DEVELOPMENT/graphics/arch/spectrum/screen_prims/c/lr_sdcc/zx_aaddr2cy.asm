
; uint zx_aaddr2cy(void *attraddr)

XDEF zx_aaddr2cy

zx_aaddr2cy:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_aaddr2cy.asm"
