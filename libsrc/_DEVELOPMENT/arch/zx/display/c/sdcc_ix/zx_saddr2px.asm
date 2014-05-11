
; uint zx_saddr2px(void *saddr)

PUBLIC _zx_saddr2px

_zx_saddr2px:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddr2px.asm"
