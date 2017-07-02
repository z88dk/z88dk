; void *tshc_pxy2aaddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_pxy2aaddr_callee

EXTERN asm_tshc_pxy2aaddr

tshc_pxy2aaddr_callee:

   pop hl
   ex (sp),hl

   jp asm_tshc_pxy2aaddr
