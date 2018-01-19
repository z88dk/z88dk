; void tshr_cls_attr(uchar ink)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_cls_attr

EXTERN asm_tshr_cls_attr

defc tshr_cls_attr = asm_tshr_cls_attr
