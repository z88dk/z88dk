; void *tshc_aaddrpup(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrpup

EXTERN zx_saddrpup

defc tshc_aaddrpup = zx_saddrpup
