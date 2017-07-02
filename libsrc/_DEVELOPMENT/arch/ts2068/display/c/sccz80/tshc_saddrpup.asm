; void *tshc_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrpup

EXTERN zx_saddrpup

defc tshc_saddrpup = zx_saddrpup
