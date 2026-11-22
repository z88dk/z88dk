; uchar tshr_saddr2cx(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddr2cx_fastcall

EXTERN asm_tshr_saddr2cx

defc _tshr_saddr2cx_fastcall = asm_tshr_saddr2cx
