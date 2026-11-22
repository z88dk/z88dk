; void *tshc_aaddr2saddr(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddr2saddr_fastcall

EXTERN asm_tshc_aaddr2saddr

defc _tshc_aaddr2saddr_fastcall = asm_tshc_aaddr2saddr
