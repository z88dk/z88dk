; void *tshc_pxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_pxy2saddr

EXTERN _zx_pxy2saddr

defc _tshc_pxy2saddr = _zx_pxy2saddr
