; void *tshc_saddrcright(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrcright

EXTERN _zx_saddrcright

defc _tshc_saddrcright = _zx_saddrcright
