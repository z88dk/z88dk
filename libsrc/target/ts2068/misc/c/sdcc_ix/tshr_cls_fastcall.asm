; void tshr_cls(uchar ink)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cls_fastcall

EXTERN asm_tshr_cls

defc _tshr_cls_fastcall = asm_tshr_cls
