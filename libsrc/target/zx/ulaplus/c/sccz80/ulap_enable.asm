; void ulap_enable(void)

SECTION code_clib
SECTION code_arch

PUBLIC ulap_enable

EXTERN asm_ulap_enable

defc ulap_enable = asm_ulap_enable
