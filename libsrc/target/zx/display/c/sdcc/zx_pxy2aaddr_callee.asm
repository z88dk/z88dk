
; void *zx_pxy2aaddr_callee(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_pxy2aaddr_callee

EXTERN asm_zx_pxy2aaddr

_zx_pxy2aaddr_callee:

   pop hl
   ex (sp),hl

   jp asm_zx_pxy2aaddr
