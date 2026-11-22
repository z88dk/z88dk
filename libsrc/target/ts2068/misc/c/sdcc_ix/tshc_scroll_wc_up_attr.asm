; void tshc_scroll_wc_up_attr(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_scroll_wc_up_attr

EXTERN l0_tshc_scroll_wc_up_attr_callee

_tshc_scroll_wc_up_attr:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   ld l,d
   jp l0_tshc_scroll_wc_up_attr_callee
