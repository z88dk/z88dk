
; void *zx_cyx2aaddr(uchar row, uchar col)

SECTION code_arch

PUBLIC zx_cyx2aaddr_callee, l0_zx_cyx2aaddr_callee

zx_cyx2aaddr_callee:

   pop af
   pop hl
   pop de
   push af

l0_zx_cyx2aaddr_callee:

   ld h,e
   
   INCLUDE "arch/zx/display/z80/asm_zx_cyx2aaddr.asm"
