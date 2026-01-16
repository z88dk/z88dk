; void zx_cls_wc_attr(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cls_wc_attr

EXTERN asm_zx_cls_wc_attr

zx_cls_wc_attr:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af
   
   jp asm_zx_cls_wc_attr
