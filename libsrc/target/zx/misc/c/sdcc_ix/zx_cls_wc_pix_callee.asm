; void zx_cls_wc_pix_callee(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_wc_pix_callee, l0_zx_cls_wc_pix_callee

EXTERN asm_zx_cls_wc_pix

_zx_cls_wc_pix_callee:

   pop hl
   pop bc
   dec sp
   ex (sp),hl
   ld l,h

l0_zx_cls_wc_pix_callee:
   
   push bc
   ex (sp),ix
   
   call asm_zx_cls_wc_pix
   
   pop ix
   ret
