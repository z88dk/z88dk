; void *tshc_aaddrcright(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrcright

EXTERN _zx_saddrcright

defc _tshc_aaddrcright = _zx_saddrcright
