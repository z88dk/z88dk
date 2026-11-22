; void *tshc_py2aaddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_py2aaddr

EXTERN asm_tshc_py2aaddr

defc tshc_py2aaddr = asm_tshc_py2aaddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_py2aaddr
defc _tshc_py2aaddr = tshc_py2aaddr
ENDIF

