
; void *zx_cyx2aaddr_callee(uchar row, uchar col)

SECTION code_arch

PUBLIC _zx_cyx2aaddr_callee, l0_zx_cyx2aaddr_callee

_zx_cyx2aaddr_callee:

   pop hl
   pop de
   ex (sp),hl

l0_zx_cyx2aaddr_callee:

   ld h,e
   
   INCLUDE "arch/zx/display/z80/asm_zx_cyx2aaddr.asm"
