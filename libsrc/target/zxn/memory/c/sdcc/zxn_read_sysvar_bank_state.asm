; unsigned int zxn_read_sysvar_bank_state(void)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_read_sysvar_bank_state

EXTERN asm_zxn_read_sysvar_bank_state

defc _zxn_read_sysvar_bank_state = asm_zxn_read_sysvar_bank_state
