; void *tshc_aaddrcleft(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrcleft

EXTERN _zx_saddrcleft

defc _tshc_aaddrcleft = _zx_saddrcleft
