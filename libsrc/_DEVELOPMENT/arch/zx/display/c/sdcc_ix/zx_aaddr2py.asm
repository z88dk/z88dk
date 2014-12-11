
; uint zx_aaddr2py(void *attraddr)

SECTION code_arch

PUBLIC _zx_aaddr2py

_zx_aaddr2py:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_aaddr2py.asm"
