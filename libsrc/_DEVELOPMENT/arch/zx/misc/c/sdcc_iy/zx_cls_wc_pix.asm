; void zx_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_wc_pix

EXTERN asm_zx_cls_wc_pix

_zx_cls_wc_pix:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   jp asm_zx_cls_wc_pix
