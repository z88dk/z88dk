SECTION code_driver

PUBLIC _asci0_flush_Rx

EXTERN asm_asci0_flush_Rx_di

defc _asci0_flush_Rx = asm_asci0_flush_Rx_di

EXTERN asm_asci0_need
defc NEED = asm_asci0_need
