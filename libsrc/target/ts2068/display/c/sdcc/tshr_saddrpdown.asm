; void *tshr_saddrpdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrpdown

EXTERN _zx_saddrpdown

defc _tshr_saddrpdown = _zx_saddrpdown
