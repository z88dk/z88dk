; void *tshc_saddrcdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrcdown

EXTERN zx_saddrcdown

defc tshc_saddrcdown = zx_saddrcdown
