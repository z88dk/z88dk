
; void *zx_pxy2aaddr_callee(uchar x, uchar y)

SECTION seg_code_arch

PUBLIC _zx_pxy2aaddr

_zx_pxy2aaddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   
   INCLUDE "arch/zx/display/z80/asm_zx_pxy2aaddr.asm"
