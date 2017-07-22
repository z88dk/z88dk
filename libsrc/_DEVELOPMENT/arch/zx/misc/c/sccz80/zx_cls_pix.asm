; void zx_cls_pix(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cls_pix

EXTERN asm_zx_cls_pix

defc zx_cls_pix = asm_zx_cls_pix
