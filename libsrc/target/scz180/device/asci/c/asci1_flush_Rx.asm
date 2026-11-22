SECTION code_driver

PUBLIC _asci1_flush_Rx

EXTERN asm_asci1_flush_Rx_di

defc _asci1_flush_Rx = asm_asci1_flush_Rx_di

EXTERN asm_asci1_need
defc NEED = asm_asci1_need
