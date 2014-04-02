
; void *zx_pxy2saddr(uchar x, uchar y)

XDEF _zx_pxy2saddr

_zx_pxy2saddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   
   INCLUDE "arch/spectrum/display/z80/asm_zx_pxy2saddr.asm"
