; void tshc_cls_wc_attr(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_wc_attr

EXTERN l0_tshc_cls_wc_attr_callee

_tshc_cls_wc_attr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l0_tshc_cls_wc_attr_callee
