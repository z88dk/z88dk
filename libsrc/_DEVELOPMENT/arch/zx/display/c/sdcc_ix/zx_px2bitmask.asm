
; uint zx_px2bitmask(uchar x)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_px2bitmask

EXTERN asm_zx_px2bitmask

_zx_px2bitmask:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_px2bitmask
