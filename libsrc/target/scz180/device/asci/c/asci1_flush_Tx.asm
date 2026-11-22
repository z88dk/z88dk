SECTION code_driver

PUBLIC _asci1_flush_Tx

EXTERN asm_asci1_flush_Tx_di

defc _asci1_flush_Tx = asm_asci1_flush_Tx_di

EXTERN asm_asci1_need
defc NEED = asm_asci1_need
