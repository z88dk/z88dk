; void *tshr_saddrcdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrcdown

EXTERN zx_saddrcdown

defc tshr_saddrcdown = zx_saddrcdown
