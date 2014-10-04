
; void *zx_aaddrcdown(void *attraddr)

SECTION seg_code_arch

PUBLIC _zx_aaddrcdown

_zx_aaddrcdown:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_aaddrcdown.asm"
