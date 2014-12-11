
; uint zx_saddr2cy(void *saddr)

SECTION code_arch

PUBLIC _zx_saddr2cy

_zx_saddr2cy:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddr2cy.asm"
