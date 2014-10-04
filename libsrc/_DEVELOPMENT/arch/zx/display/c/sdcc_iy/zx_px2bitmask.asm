
; uint zx_px2bitmask(uchar x)

SECTION seg_code_arch

PUBLIC _zx_px2bitmask

_zx_px2bitmask:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_px2bitmask.asm"
