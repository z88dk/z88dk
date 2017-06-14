; void *tshr_saddrcleft(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrcleft_fastcall

EXTERN asm_tshr_saddrcleft

defc _tshr_saddrcleft_fastcall = asm_tshr_saddrcleft
