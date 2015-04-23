
; void *zx_saddrpleft_callee(void *saddr, uchar bitmask)

SECTION code_arch

PUBLIC _zx_saddrpleft_callee

_zx_saddrpleft_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "arch/zx/display/z80/asm_zx_saddrpleft.asm"
