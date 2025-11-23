; unsigned int zxn_read_sysvar_bank_state(void)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_read_sysvar_bank_state

EXTERN asm_zxn_read_sysvar_bank_state

defc zxn_read_sysvar_bank_state = asm_zxn_read_sysvar_bank_state

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zxn_read_sysvar_bank_state
defc _zxn_read_sysvar_bank_state = zxn_read_sysvar_bank_state
ENDIF

