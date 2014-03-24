
; void *zx_pxy2aaddr_callee(uchar x, uchar y)

XDEF zx_pxy2aaddr

zx_pxy2aaddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   
   INCLUDE "arch/spectrum/display/z80/asm_zx_pxy2aaddr.asm"
