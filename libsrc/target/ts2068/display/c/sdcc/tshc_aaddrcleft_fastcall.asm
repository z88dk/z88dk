; void *tshc_aaddrcleft(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrcleft_fastcall

EXTERN _zx_saddrcleft_fastcall

defc _tshc_aaddrcleft_fastcall = _zx_saddrcleft_fastcall
