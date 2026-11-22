; void *tshc_cy2aaddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cy2aaddr_fastcall

EXTERN asm_tshc_cy2aaddr

defc _tshc_cy2aaddr_fastcall = asm_tshc_cy2aaddr
