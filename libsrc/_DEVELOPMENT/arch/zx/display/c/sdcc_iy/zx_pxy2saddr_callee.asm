
; void *zx_pxy2saddr_callee(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_pxy2saddr_callee, l0_zx_pxy2saddr_callee

EXTERN asm_zx_pxy2saddr

_zx_pxy2saddr_callee:

   pop af
   pop hl
   pop de
   push af

l0_zx_pxy2saddr_callee:

   ld h,e
   
   jp asm_zx_pxy2saddr
