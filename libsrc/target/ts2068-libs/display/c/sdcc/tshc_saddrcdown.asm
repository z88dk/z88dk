; void *tshc_saddrcdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrcdown

EXTERN _zx_saddrcdown

defc _tshc_saddrcdown = _zx_saddrcdown
