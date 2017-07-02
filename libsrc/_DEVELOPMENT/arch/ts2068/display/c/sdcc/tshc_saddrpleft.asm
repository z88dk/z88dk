; void *tshc_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrpleft

EXTERN _zx_saddrpleft

defc _tshc_saddrpleft = _zx_saddrpleft
