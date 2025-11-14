; void *tshc_saddrcleft(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrcleft_fastcall

EXTERN _zx_saddrcleft_fastcall

defc _tshc_saddrcleft_fastcall = _zx_saddrcleft_fastcall
