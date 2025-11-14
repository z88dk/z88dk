; void *tshc_aaddrpright(void *aaddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrpright

EXTERN _zx_saddrpright

defc _tshc_aaddrpright = _zx_saddrpright
