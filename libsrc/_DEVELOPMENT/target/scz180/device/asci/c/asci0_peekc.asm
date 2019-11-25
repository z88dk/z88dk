SECTION code_driver

PUBLIC _asci0_peekc

EXTERN asm_asci0_peekc

defc _asci0_peekc = asm_asci0_peekc

EXTERN asm_asci0_need
defc NEED = asm_asci0_need
