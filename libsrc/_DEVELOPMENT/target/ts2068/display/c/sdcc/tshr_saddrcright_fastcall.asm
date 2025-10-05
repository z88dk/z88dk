; void *tshr_saddrcright(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrcright_fastcall

EXTERN asm_tshr_saddrcright

defc _tshr_saddrcright_fastcall = asm_tshr_saddrcright
