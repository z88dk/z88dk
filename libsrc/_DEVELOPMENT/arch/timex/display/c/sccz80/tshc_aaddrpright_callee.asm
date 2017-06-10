; void *tshc_aaddrpright(void *aaddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrpright_callee

EXTERN zx_saddrpright_callee

defc tshc_aaddrpright_callee = zx_saddrpright_callee
