; void tshr_cls_pix(uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cls_pix_fastcall

EXTERN asm_tshr_cls_pix

defc _tshr_cls_pix_fastcall = asm_tshr_cls_pix
