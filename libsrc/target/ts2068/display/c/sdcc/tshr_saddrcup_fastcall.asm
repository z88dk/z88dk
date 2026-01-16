; void *tshr_saddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrcup_fastcall

EXTERN _zx_saddrcup_fastcall

defc _tshr_saddrcup_fastcall = _zx_saddrcup_fastcall
