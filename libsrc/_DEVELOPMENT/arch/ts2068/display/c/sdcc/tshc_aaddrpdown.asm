; void *tshc_aaddrpdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrpdown

EXTERN _zx_saddrpdown

defc _tshc_aaddrpdown = _zx_saddrpdown
