; void *tshr_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cxy2saddr_callee

EXTERN asm_zx_cxy2saddr

_tshr_cxy2saddr_callee:

   pop hl
   ex (sp),hl

   jp asm_zx_cxy2saddr
