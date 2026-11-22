; void ulap_disable(void)

SECTION code_clib
SECTION code_arch

PUBLIC ulap_disable

EXTERN asm_ulap_disable

defc ulap_disable = asm_ulap_disable
