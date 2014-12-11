
; void *zx_saddrpdown(void *saddr)

SECTION code_arch

PUBLIC _zx_saddrpdown

_zx_saddrpdown:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddrpdown.asm"
