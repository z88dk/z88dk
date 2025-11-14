
; uint zx_bitmask2px(uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_bitmask2px

EXTERN asm_zx_bitmask2px

_zx_bitmask2px:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_bitmask2px
