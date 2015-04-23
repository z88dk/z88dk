
; void *zx_pxy2saddr_callee(uchar x, uchar y)

SECTION code_arch

PUBLIC _zx_pxy2saddr_callee, l0_zx_pxy2saddr_callee

_zx_pxy2saddr_callee:

   pop af
   pop hl
   pop de
   push af

l0_zx_pxy2saddr_callee:

   ld h,e
   
   INCLUDE "arch/zx/display/z80/asm_zx_pxy2saddr.asm"
