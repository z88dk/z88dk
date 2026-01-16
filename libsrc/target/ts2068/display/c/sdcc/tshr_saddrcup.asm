; void *tshr_saddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrcup

EXTERN _zx_saddrcup

defc _tshr_saddrcup = _zx_saddrcup
