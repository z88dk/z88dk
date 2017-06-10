; void *tshr_saddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrcup

EXTERN zx_saddrcup

defc tshr_saddrcup = zx_saddrcup
