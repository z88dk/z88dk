; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_scroll_up_pix(uchar prows, uchar pix)
;
; Scroll screen upward by number of pixels.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_scroll_up_pix
PUBLIC asm0_tshc_scroll_up_pix

PUBLIC asm_zx_scroll_up_pix
PUBLIC asm0_zx_scroll_up_pix

defc asm_tshc_scroll_up_pix = asm_zx_scroll_up_pix
defc asm0_tshc_scroll_up_pix = asm0_zx_scroll_up_pix
