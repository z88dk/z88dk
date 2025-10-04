SECTION code_driver

PUBLIC _asci0_flush_Tx

EXTERN asm_asci0_flush_Tx_di

defc _asci0_flush_Tx = asm_asci0_flush_Tx_di

EXTERN asm_asci0_need
defc NEED = asm_asci0_need
