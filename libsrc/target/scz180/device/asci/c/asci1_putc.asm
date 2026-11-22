SECTION code_driver

PUBLIC _asci1_putc

EXTERN asm_asci1_putc

defc _asci1_putc = asm_asci1_putc

EXTERN asm_asci1_need
defc NEED = asm_asci1_need
