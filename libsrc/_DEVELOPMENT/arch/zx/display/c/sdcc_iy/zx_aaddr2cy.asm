
; uint zx_aaddr2cy(void *attraddr)

SECTION seg_code_arch

PUBLIC _zx_aaddr2cy

_zx_aaddr2cy:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_aaddr2cy.asm"
