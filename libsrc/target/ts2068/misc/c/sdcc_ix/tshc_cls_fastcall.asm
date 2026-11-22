; void tshc_cls(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_fastcall

EXTERN asm_tshc_cls

defc _tshc_cls_fastcall = asm_tshc_cls
