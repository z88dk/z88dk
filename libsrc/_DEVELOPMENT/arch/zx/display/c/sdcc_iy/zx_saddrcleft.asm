
; void *zx_saddrcleft(void *saddr)

SECTION code_arch

PUBLIC _zx_saddrcleft

_zx_saddrcleft:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddrcleft.asm"
