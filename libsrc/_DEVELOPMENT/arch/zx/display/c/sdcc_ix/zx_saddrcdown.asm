
; void *zx_saddrcdown(void *saddr)

SECTION code_arch

PUBLIC _zx_saddrcdown

_zx_saddrcdown:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddrcdown.asm"
