; void tshc_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_scroll_wc_up_pix_callee

EXTERN asm0_tshc_scroll_wc_up_pix

tshc_scroll_wc_up_pix_callee:

   pop af
   pop hl
   pop de
   pop ix
   push af

   jp asm0_tshc_scroll_wc_up_pix

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_scroll_wc_up_pix_callee
defc _tshc_scroll_wc_up_pix_callee = tshc_scroll_wc_up_pix_callee
ENDIF

