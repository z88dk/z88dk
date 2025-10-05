; void tshc_cls_wc_attr(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_wc_attr

EXTERN asm_tshc_cls_wc_attr

_tshc_cls_wc_attr:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   jp asm_tshc_cls_wc_attr
