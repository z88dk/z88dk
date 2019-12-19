SECTION code_driver

PUBLIC _asci0_putc

EXTERN asm_asci0_putc

defc _asci0_putc = asm_asci0_putc

EXTERN asm_asci0_need
defc NEED = asm_asci0_need
