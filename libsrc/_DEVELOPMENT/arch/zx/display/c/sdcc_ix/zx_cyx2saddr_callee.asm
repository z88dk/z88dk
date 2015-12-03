
; void *zx_cyx2saddr_callee(uchar row, uchar col)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cyx2saddr_callee, l0_zx_cyx2saddr_callee

EXTERN asm_zx_cyx2saddr

_zx_cyx2saddr_callee:

   pop hl
   pop de
   ex (sp),hl

l0_zx_cyx2saddr_callee:

   ld h,e
   
   jp asm_zx_cyx2saddr
