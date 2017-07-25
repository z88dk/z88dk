; void zx_cls_wc_attr_callee(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cls_wc_attr_callee

EXTERN asm_zx_cls_wc_attr

zx_cls_wc_attr_callee:

   pop af
   pop hl
   pop ix
   push af

   jp asm_zx_cls_wc_attr
