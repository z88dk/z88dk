; void *tshc_aaddrcdown(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrcdown

EXTERN zx_saddrcdown

defc tshc_aaddrcdown = zx_saddrcdown
