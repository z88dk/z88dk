
; uint zx_saddr2py(void *saddr)

XDEF zx_saddr2py

zx_saddr2py:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_saddr2py.asm"
