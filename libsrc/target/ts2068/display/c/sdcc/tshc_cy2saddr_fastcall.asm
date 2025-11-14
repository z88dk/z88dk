; void *tshc_cy2saddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cy2saddr_fastcall

EXTERN _zx_cy2saddr_fastcall

defc _tshc_cy2saddr_fastcall = _zx_cy2saddr_fastcall
