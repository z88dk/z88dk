; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_cls_wc_pix(struct r_Rect8 *r, uchar pix)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cls_wc_pix

EXTERN asm_zx_cls_wc_pix

defc asm_tshc_cls_wc_pix = asm_zx_cls_wc_pix
