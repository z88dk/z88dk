; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)
;
; Scroll the rectangular area upward by rows characters.
; Clear the vacated area.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_scroll_wc_up_pix
PUBLIC asm0_tshc_scroll_wc_up_pix

EXTERN asm_zx_scroll_wc_up_pix
EXTERN asm0_zx_scroll_wc_up_pix

defc asm_tshc_scroll_wc_up_pix = asm_zx_scroll_wc_up_pix
defc asm0_tshc_scroll_wc_up_pix = asm0_zx_scroll_wc_up_pix

   ; enter : de = number of rows to scroll upward by
   ;          l = screen byte
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl
