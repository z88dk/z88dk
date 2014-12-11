
; void zx_border(uchar colour)

SECTION code_arch

PUBLIC _zx_border

_zx_border:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/misc/z80/asm_zx_border.asm"
