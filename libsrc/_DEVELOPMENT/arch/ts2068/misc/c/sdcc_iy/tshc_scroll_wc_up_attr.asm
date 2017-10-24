; void tshc_scroll_wc_up_attr(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_scroll_wc_up_attr

EXTERN asm0_tshc_scroll_wc_up_attr

_tshc_scroll_wc_up_attr:

   pop af
   pop ix
   pop de
   
   push de
   push de
   push af
   
   ld l,d
   jp asm0_tshc_scroll_wc_up_attr
