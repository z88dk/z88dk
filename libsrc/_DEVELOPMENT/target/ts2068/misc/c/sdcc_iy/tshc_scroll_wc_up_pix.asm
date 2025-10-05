; void tshc_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_scroll_wc_up_pix

EXTERN asm0_tshc_scroll_wc_up_pix

_tshc_scroll_wc_up_pix:

   pop af
   pop ix
   pop de
   
   push de
   push de
   push af
   
   ld l,d
   jp asm0_tshc_scroll_wc_up_pix
