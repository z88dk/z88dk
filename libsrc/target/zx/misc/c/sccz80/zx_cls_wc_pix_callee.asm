; void zx_cls_wc_pix_callee(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cls_wc_pix_callee

EXTERN asm_zx_cls_wc_pix

zx_cls_wc_pix_callee:

   pop af
   pop hl
   pop ix
   push af

   jp asm_zx_cls_wc_pix
