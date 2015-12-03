
; void *zx_pxy2aaddr_callee(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC zx_pxy2aaddr_callee, l0_zx_pxy2aaddr_callee

EXTERN asm_zx_pxy2aaddr

zx_pxy2aaddr_callee:

   pop hl
   pop de
   ex (sp),hl

l0_zx_pxy2aaddr_callee:

   ld h,e
   
   jp asm_zx_pxy2aaddr
