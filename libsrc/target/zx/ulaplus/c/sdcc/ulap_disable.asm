; void ulap_disable(void)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_disable

EXTERN asm_ulap_disable

defc _ulap_disable = asm_ulap_disable
