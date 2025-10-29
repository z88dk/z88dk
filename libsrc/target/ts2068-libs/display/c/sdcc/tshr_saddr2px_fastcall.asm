; uint tshr_saddr2px(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddr2px_fastcall

EXTERN asm_tshr_saddr2px

defc _tshr_saddr2px_fastcall = asm_tshr_saddr2px
