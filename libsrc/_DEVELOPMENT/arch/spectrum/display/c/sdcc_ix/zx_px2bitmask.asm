
; uint zx_px2bitmask(uchar x)

PUBLIC _zx_px2bitmask

_zx_px2bitmask:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_px2bitmask.asm"
