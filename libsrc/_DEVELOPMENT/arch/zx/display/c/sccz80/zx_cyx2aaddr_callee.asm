
; void *zx_cyx2aaddr(uchar row, uchar col)

SECTION code_arch

PUBLIC zx_cyx2aaddr_callee

zx_cyx2aaddr_callee:

   pop hl
   pop de
   ex (sp),hl
   
   ld h,l
   ld l,e
   
   INCLUDE "arch/zx/display/z80/asm_zx_cyx2aaddr.asm"
