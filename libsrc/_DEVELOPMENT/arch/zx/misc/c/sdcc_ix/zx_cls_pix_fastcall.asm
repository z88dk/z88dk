; void zx_cls_pix(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_pix_fastcall

EXTERN asm_zx_cls_pix

defc _zx_cls_pix_fastcall = asm_zx_cls_pix
