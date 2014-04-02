
; void *zx_cy2saddr(uchar row)

XDEF _zx_cy2saddr

_zx_cy2saddr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_cy2saddr.asm"
