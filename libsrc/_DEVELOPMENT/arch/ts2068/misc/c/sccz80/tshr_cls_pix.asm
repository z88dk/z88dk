; void tshr_cls_pix(uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_cls_pix

EXTERN asm_tshr_cls_pix

defc tshr_cls_pix = asm_tshr_cls_pix
