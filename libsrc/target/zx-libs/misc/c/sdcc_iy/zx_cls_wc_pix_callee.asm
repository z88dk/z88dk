; void zx_cls_wc_pix_callee(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_wc_pix_callee

EXTERN asm_zx_cls_wc_pix

_zx_cls_wc_pix_callee:

   pop hl
   pop ix
   dec sp
   ex (sp),hl
   
   ld l,h
   jp asm_zx_cls_wc_pix
