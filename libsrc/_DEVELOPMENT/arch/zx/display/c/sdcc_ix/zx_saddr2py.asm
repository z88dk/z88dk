
; uint zx_saddr2py(void *saddr)

SECTION seg_code_arch

PUBLIC _zx_saddr2py

_zx_saddr2py:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddr2py.asm"
