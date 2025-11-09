; void *tshc_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cxy2saddr

EXTERN _zx_cxy2saddr

defc _tshc_cxy2saddr = _zx_cxy2saddr
