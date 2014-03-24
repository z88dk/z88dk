
; void *zx_pxy2saddr(uchar x, uchar y)

XDEF zx_pxy2saddr_callee

zx_pxy2saddr_callee:

   pop hl
   pop de
   ex (sp),hl
   
   ld h,e
   
   INCLUDE "arch/spectrum/display/z80/asm_zx_pxy2saddr.asm"
