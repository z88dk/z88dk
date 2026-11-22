; void *tshc_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cxy2saddr_callee

EXTERN _zx_cxy2saddr_callee

defc _tshc_cxy2saddr_callee = _zx_cxy2saddr_callee
