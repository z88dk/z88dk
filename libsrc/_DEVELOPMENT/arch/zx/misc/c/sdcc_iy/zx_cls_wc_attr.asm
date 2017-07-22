; void zx_cls_wc_attr(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_wc_attr

EXTERN asm_zx_cls_wc_attr

_zx_cls_wc_attr:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   jp asm_zx_cls_wc_attr
