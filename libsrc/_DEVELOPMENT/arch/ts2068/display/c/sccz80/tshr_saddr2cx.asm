; uchar tshr_saddr2cx(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddr2cx

EXTERN asm_tshr_saddr2cx

defc tshr_saddr2cx = asm_tshr_saddr2cx
