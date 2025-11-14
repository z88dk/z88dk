; void *tshc_aaddrpdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrpdown_fastcall

EXTERN _zx_saddrpdown_fastcall

defc _tshc_aaddrpdown_fastcall = _zx_saddrpdown_fastcall
