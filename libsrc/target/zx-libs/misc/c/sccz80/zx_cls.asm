
; void zx_cls(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cls

EXTERN asm_zx_cls

defc zx_cls = asm_zx_cls
