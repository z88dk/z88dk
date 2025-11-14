; void *tshc_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrpup_fastcall

EXTERN _zx_saddrpup_fastcall

defc _tshc_saddrpup_fastcall = _zx_saddrpup_fastcall
