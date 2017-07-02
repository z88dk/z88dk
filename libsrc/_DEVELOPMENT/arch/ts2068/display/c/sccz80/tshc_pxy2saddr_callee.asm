; void *tshc_pxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_pxy2saddr_callee

EXTERN zx_pxy2saddr_callee

defc tshc_pxy2saddr_callee = zx_pxy2saddr_callee
