; void *tshc_saddrpright(void *saddr, uint bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrpright_callee

EXTERN zx_saddrpright_callee

defc tshc_saddrpright_callee = zx_saddrpright_callee
