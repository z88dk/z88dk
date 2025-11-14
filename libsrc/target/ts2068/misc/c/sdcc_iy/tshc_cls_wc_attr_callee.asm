; void tshc_cls_wc_attr(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_wc_attr_callee

EXTERN asm_tshc_cls_wc_attr

_tshc_cls_wc_attr_callee:

   pop hl
   pop ix
   dec sp
   ex (sp),hl
   
   ld l,h
   jp asm_tshc_cls_wc_attr
