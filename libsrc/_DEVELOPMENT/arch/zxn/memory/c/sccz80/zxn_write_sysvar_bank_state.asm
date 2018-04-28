; void zxn_write_sysvar_bank_state(unsigned int state)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_write_sysvar_bank_state

EXTERN asm_zxn_write_sysvar_bank_state

defc zxn_write_sysvar_bank_state = asm_zxn_write_sysvar_bank_state
