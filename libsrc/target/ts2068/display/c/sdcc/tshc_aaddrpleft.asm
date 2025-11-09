; void *tshc_aaddrpleft(void *aaddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrpleft

EXTERN _zx_saddrpleft

defc _tshc_aaddrpleft = _zx_saddrpleft
