; uint tshr_saddr2px(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddr2px

EXTERN asm_tshr_saddr2px

defc tshr_saddr2px = asm_tshr_saddr2px
