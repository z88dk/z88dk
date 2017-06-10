; void *tshc_aaddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrcup_fastcall

EXTERN _zx_saddrcup_fastcall

defc _tshc_aaddrcup_fastcall = _zx_saddrcup_fastcall
