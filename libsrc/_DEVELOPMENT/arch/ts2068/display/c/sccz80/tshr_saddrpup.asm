; void *tshr_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrpup

EXTERN zx_saddrpup

defc tshr_saddrpup = zx_saddrpup
