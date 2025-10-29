; void *tshr_saddrpdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrpdown_fastcall

EXTERN _zx_saddrpdown_fastcall

defc _tshr_saddrpdown_fastcall = _zx_saddrpdown_fastcall
