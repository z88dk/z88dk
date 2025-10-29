; void *tshr_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrpup

EXTERN _zx_saddrpup

defc _tshr_saddrpup = _zx_saddrpup
