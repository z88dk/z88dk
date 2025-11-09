; void tshc_cls_pix(unsigned char pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_pix_fastcall

EXTERN asm_tshc_cls_pix

defc _tshc_cls_pix_fastcall = asm_tshc_cls_pix
