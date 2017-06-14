; void *tshc_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrpleft

EXTERN zx_saddrpleft

defc tshc_saddrpleft = zx_saddrpleft
