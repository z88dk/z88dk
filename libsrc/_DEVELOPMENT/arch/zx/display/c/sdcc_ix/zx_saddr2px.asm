
; uint zx_saddr2px(void *saddr)

SECTION seg_code_arch

PUBLIC _zx_saddr2px

_zx_saddr2px:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddr2px.asm"
