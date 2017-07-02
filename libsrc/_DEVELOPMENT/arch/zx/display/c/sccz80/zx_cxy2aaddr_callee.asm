
; void *zx_cxy2aaddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cxy2aaddr_callee

EXTERN asm_zx_cxy2aaddr

zx_cxy2aaddr_callee:

   pop hl
   pop de
   ex (sp),hl

   ld h,e
   jp asm_zx_cxy2aaddr
