
; uint zx_bitmask2px(uchar bitmask)

XDEF _zx_bitmask2px

_zx_bitmask2px:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_bitmask2px.asm"
