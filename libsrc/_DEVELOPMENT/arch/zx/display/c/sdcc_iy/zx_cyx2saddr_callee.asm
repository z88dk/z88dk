
; void *zx_cyx2saddr_callee(uchar row, uchar col)

SECTION code_arch

PUBLIC _zx_cyx2saddr_callee, l0_zx_cyx2saddr_callee

_zx_cyx2saddr_callee:

   pop hl
   pop de
   ex (sp),hl

l0_zx_cyx2saddr_callee:

   ld h,e
   
   INCLUDE "arch/zx/display/z80/asm_zx_cyx2saddr.asm"
