
; void *zx_cyx2aaddr(uchar row, uchar col)

XDEF zx_cyx2aaddr_callee

zx_cyx2aaddr_callee:

   pop hl
   pop de
   ex (sp),hl
   
   ld h,l
   ld l,e
   
   INCLUDE "arch/spectrum/display/z80/asm_zx_cyx2aaddr.asm"
