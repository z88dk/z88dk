
; void *zx_pxy2aaddr_callee(uchar x, uchar y)

PUBLIC _zx_pxy2aaddr

_zx_pxy2aaddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   
   INCLUDE "arch/spectrum/display/z80/asm_zx_pxy2aaddr.asm"
