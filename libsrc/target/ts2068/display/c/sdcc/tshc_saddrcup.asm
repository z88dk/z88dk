; void *tshc_saddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrcup

EXTERN _zx_saddrcup

defc _tshc_saddrcup = _zx_saddrcup
