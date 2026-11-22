; void *tshr_saddrcdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrcdown_fastcall

EXTERN _zx_saddrcdown_fastcall

defc _tshr_saddrcdown_fastcall = _zx_saddrcdown_fastcall
