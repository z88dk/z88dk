; void *tshc_saddrpdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrpdown

EXTERN _zx_saddrpdown

defc _tshc_saddrpdown = _zx_saddrpdown
