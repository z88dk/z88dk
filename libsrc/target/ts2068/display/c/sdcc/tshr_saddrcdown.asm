; void *tshr_saddrcdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrcdown

EXTERN _zx_saddrcdown

defc _tshr_saddrcdown = _zx_saddrcdown
