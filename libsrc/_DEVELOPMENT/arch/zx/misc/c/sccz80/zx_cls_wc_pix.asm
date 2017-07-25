; void zx_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cls_wc_pix

EXTERN asm_zx_cls_wc_pix

zx_cls_wc_pix:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af
   
   jp asm_zx_cls_wc_pix
