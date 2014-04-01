
; void zx_border(uchar colour)

XDEF zx_border

zx_border:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/z80/asm_zx_border.asm"
