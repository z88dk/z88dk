
; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_cls_pix(unsigned char pix)
;
; Clear screen pixels.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cls_pix

EXTERN asm_zx_cls_pix

defc asm_tshc_cls_pix = asm_zx_cls_pix
