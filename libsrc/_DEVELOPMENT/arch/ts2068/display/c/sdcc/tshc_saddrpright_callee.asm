; void *tshc_saddrpright(void *saddr, uint bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrpright_callee

EXTERN _zx_saddrpright_callee

defc _tshc_saddrpright_callee = _zx_saddrpright_callee
