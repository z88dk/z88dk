; void *tshc_saddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrcup_fastcall

EXTERN _zx_saddrcup_fastcall

defc _tshc_saddrcup_fastcall = _zx_saddrcup_fastcall
