
; uint zx_aaddr2py(void *attraddr)

XDEF zx_aaddr2py

zx_aaddr2py:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_aaddr2py.asm"
