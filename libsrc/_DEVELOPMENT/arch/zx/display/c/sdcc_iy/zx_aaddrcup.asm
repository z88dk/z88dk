
; void *zx_aaddrcup(void *aaddr)

SECTION code_arch

PUBLIC _zx_aaddrcup

_zx_aaddrcup:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_aaddrcup.asm"
