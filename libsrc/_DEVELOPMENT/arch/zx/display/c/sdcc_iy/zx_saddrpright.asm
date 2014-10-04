
; void *zx_saddrpright(void *saddr, uint bitmask)

SECTION seg_code_arch

PUBLIC _zx_saddrpright

_zx_saddrpright:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "arch/zx/display/z80/asm_zx_saddrpright.asm"
