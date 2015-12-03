
; void zx_cls_wc_callee(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_wc_callee, l0_zx_cls_wc_callee

EXTERN asm_zx_cls_wc

_zx_cls_wc_callee:

   pop hl
   pop bc
   ex (sp),hl

l0_zx_cls_wc_callee:
   
   push bc
   ex (sp),ix
   
   call asm_zx_cls_wc
   
   pop ix
   ret
