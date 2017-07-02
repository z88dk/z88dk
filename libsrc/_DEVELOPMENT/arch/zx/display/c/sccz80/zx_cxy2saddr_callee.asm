
; void *zx_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cxy2saddr_callee

EXTERN asm_zx_cxy2saddr

zx_cxy2saddr_callee:

   pop hl
   pop de
   ex (sp),hl

   ld h,e
   jp asm_zx_cxy2saddr
