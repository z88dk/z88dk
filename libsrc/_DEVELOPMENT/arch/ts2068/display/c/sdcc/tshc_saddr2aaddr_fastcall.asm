; void *tshc_saddr2aaddr(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddr2aaddr_fastcall

EXTERN asm_tshc_saddr2aaddr

defc _tshc_saddr2aaddr_fastcall = asm_tshc_saddr2aaddr
