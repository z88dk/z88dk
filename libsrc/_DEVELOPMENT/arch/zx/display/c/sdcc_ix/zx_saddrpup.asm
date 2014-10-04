
; void *zx_saddrpup(void *saddr)

SECTION seg_code_arch

PUBLIC _zx_saddrpup

_zx_saddrpup:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddrpup.asm"
