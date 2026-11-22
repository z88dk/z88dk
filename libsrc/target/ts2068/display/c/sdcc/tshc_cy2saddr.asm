; void *tshc_cy2saddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cy2saddr

EXTERN _zx_cy2saddr

defc _tshc_cy2saddr = _zx_cy2saddr
