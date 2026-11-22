; void *tshc_aaddrcright(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrcright_fastcall

EXTERN _zx_saddrcright_fastcall

defc _tshc_aaddrcright_fastcall = _zx_saddrcright_fastcall
