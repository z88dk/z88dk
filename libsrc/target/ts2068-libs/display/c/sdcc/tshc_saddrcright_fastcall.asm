; void *tshc_saddrcright(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrcright_fastcall

EXTERN _zx_saddrcright_fastcall

defc _tshc_saddrcright_fastcall = _zx_saddrcright_fastcall
