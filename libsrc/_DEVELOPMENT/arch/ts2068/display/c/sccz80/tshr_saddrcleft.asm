; void *tshr_saddrcleft(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrcleft

EXTERN asm_tshr_saddrcleft

defc tshr_saddrcleft = asm_tshr_saddrcleft
