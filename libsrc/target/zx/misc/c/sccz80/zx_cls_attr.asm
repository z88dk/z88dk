; void zx_cls_attr(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cls_attr

EXTERN asm_zx_cls_attr

defc zx_cls_attr = asm_zx_cls_attr
