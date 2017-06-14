; void *tshr_saddrcright(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrcright

EXTERN asm_tshr_saddrcright

defc tshr_saddrcright = asm_tshr_saddrcright
