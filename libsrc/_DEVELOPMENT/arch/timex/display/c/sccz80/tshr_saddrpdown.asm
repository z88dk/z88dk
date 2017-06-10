; void *tshr_saddrpdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrpdown

EXTERN zx_saddrpdown

defc tshr_saddrpdown = zx_saddrpdown
