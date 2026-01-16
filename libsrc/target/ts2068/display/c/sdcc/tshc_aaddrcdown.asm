; void *tshc_aaddrcdown(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrcdown

EXTERN _zx_saddrcdown

defc _tshc_aaddrcdown = _zx_saddrcdown
