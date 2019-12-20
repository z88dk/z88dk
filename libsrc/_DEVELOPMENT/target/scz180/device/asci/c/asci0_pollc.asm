SECTION code_driver

PUBLIC _asci0_pollc

EXTERN asm_asci0_pollc

defc _asci0_pollc = asm_asci0_pollc

EXTERN asm_asci0_need
defc NEED = asm_asci0_need
