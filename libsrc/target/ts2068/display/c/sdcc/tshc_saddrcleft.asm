; void *tshc_saddrcleft(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrcleft

EXTERN _zx_saddrcleft

defc _tshc_saddrcleft = _zx_saddrcleft
