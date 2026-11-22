
; void *zx_cxy2saddr_callee(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cxy2saddr_callee

EXTERN asm_zx_cxy2saddr

_zx_cxy2saddr_callee:

   pop hl
   ex (sp),hl
   
   jp asm_zx_cxy2saddr
