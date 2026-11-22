; void *tshc_saddrpright(void *saddr, uint bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrpright

EXTERN _zx_saddrpright

defc _tshc_saddrpright = _zx_saddrpright
