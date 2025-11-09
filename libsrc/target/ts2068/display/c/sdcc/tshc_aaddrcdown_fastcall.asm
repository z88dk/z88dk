; void *tshc_aaddrcdown(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrcdown_fastcall

EXTERN _zx_saddrcdown_fastcall

defc _tshc_aaddrcdown_fastcall = _zx_saddrcdown_fastcall
