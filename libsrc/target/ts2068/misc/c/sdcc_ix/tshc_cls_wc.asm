; void tshc_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_wc

EXTERN l0_tshc_cls_wc_callee

_tshc_cls_wc:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l0_tshc_cls_wc_callee
