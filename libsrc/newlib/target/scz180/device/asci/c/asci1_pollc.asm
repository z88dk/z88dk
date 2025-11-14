SECTION code_driver

PUBLIC _asci1_pollc

EXTERN asm_asci1_pollc

defc _asci1_pollc = asm_asci1_pollc

EXTERN asm_asci1_need
defc NEED = asm_asci1_need
