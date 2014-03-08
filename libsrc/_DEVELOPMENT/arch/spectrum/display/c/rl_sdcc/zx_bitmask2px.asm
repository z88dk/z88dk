
; uint zx_bitmask2px(uchar bitmask)

XDEF zx_bitmask2px

zx_bitmask2px:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_bitmask2px.asm"
