; void zx_cls_attr(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_attr_fastcall

EXTERN asm_zx_cls_attr

defc _zx_cls_attr_fastcall = asm_zx_cls_attr
