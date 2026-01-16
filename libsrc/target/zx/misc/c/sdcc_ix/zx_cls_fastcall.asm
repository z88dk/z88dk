
; void zx_cls_fastcall(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_fastcall

EXTERN asm_zx_cls

defc _zx_cls_fastcall = asm_zx_cls
