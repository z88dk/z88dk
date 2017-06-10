; void *tshc_py2aaddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_py2aaddr

EXTERN asm_tshc_py2aaddr

defc tshc_py2aaddr = asm_tshc_py2aaddr
