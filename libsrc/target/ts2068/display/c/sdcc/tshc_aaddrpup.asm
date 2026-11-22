; void *tshc_aaddrpup(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrpup

EXTERN _zx_saddrpup

defc _tshc_aaddrpup = _zx_saddrpup
