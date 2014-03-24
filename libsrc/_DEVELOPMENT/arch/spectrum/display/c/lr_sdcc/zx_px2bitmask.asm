
; uint zx_px2bitmask(uchar x)

XDEF zx_px2bitmask

zx_px2bitmask:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_px2bitmask.asm"
