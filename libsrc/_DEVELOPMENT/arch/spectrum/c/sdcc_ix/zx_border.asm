
; void zx_border(uchar colour)

PUBLIC _zx_border

_zx_border:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/z80/asm_zx_border.asm"
