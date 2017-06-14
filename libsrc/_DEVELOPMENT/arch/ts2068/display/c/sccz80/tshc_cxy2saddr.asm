; void *tshc_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cxy2saddr

EXTERN zx_cxy2saddr

defc tshc_cxy2saddr = zx_cxy2saddr
