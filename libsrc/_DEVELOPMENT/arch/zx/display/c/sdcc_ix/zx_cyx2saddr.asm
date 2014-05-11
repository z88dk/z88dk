
; void *zx_cyx2saddr(uchar row, uchar col)

PUBLIC _zx_cyx2saddr

_zx_cyx2saddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   
   INCLUDE "arch/zx/display/z80/asm_zx_cyx2saddr.asm"
