; void tshc_cls_attr(unsigned char attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_attr_fastcall

EXTERN asm_tshc_cls_attr

defc _tshc_cls_attr_fastcall = asm_tshc_cls_attr
