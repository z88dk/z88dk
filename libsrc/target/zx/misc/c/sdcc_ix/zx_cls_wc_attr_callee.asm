; void zx_cls_wc_attr_callee(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_wc_attr_callee, l0_zx_cls_wc_attr_callee

EXTERN asm_zx_cls_wc_attr

_zx_cls_wc_attr_callee:

   pop hl
   pop bc
   dec sp
   ex (sp),hl
   ld l,h

l0_zx_cls_wc_attr_callee:
   
   push bc
   ex (sp),ix
   
   call asm_zx_cls_wc_attr
   
   pop ix
   ret
