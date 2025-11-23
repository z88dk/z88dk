; void tshr_cls_attr(uchar ink)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cls_attr_fastcall

EXTERN asm_tshr_cls_attr

defc _tshr_cls_attr_fastcall = asm_tshr_cls_attr
