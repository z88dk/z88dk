; void *tshc_py2aaddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_py2aaddr_fastcall

EXTERN asm_tshc_py2aaddr

defc _tshc_py2aaddr_fastcall = asm_tshc_py2aaddr
