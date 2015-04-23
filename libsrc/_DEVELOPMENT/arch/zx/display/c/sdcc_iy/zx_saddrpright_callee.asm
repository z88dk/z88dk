
; void *zx_saddrpright_callee(void *saddr, uint bitmask)

SECTION code_arch

PUBLIC _zx_saddrpright_callee

_zx_saddrpright_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "arch/zx/display/z80/asm_zx_saddrpright.asm"
