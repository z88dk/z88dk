; void *tshc_pxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_pxy2saddr_callee

EXTERN _zx_pxy2saddr_callee

defc _tshc_pxy2saddr_callee = _zx_pxy2saddr_callee
