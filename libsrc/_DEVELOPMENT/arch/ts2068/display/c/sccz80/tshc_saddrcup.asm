; void *tshc_saddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrcup

EXTERN zx_saddrcup

defc tshc_saddrcup = zx_saddrcup
