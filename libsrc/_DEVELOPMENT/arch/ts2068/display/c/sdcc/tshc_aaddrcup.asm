; void *tshc_aaddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrcup

EXTERN _zx_saddrcup

defc _tshc_aaddrcup = _zx_saddrcup
