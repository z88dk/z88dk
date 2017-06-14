; void *tshc_aaddrpleft(void *aaddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrpleft

EXTERN zx_saddrpleft

defc tshc_aaddrpleft = zx_saddrpleft
