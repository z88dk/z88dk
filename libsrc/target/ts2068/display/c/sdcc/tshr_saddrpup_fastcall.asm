; void *tshr_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrpup_fastcall

EXTERN _zx_saddrpup_fastcall

defc _tshr_saddrpup_fastcall = _zx_saddrpup_fastcall
