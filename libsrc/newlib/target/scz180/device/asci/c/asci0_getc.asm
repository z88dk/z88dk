SECTION code_driver

PUBLIC _asci0_getc

EXTERN asm_asci0_getc

defc _asci0_getc = asm_asci0_getc

EXTERN asm_asci0_need
defc NEED = asm_asci0_need
