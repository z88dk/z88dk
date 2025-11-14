; void *tshc_aaddrpright(void *aaddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrpright_callee

EXTERN _zx_saddrpright_callee

defc _tshc_aaddrpright_callee = _zx_saddrpright_callee
