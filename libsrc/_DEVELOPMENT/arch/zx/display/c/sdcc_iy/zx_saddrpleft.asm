
; void *zx_saddrpleft(void *saddr, uchar bitmask)

SECTION seg_code_arch

PUBLIC _zx_saddrpleft

_zx_saddrpleft:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "arch/zx/display/z80/asm_zx_saddrpleft.asm"
