; void *tshc_aaddrpup(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrpup_fastcall

EXTERN _zx_saddrpup_fastcall

defc _tshc_aaddrpup_fastcall = _zx_saddrpup_fastcall
